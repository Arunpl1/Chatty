# This is used to handle new messages sent from the command bar
# In theory, this would be it's own "network controller", but for demonstration sake
# I am putting it all inside of the commandbar controller

App.CommandBarController = Ember.Controller.extend
  
  # This is used for our connection state
  isConnected: false

  # This is used for holding on to our websockets connector
  _fayeClient: null

  # This is triggered when we type in a message into the text box and hit return
  # We'll want to send the message over to our chat window controller and also
  # send it back to our server to send to other clients

  processMessage: (message) ->
    # Our message has to have some sort of length to do something
    if message.length
      if message[0] == "/" then @_command(message) else @_message(message)

  ###
  # Private
  ###

  # Handles a / command 
  _command: (message) ->
    # Remove spaces from our command
    args = message.split(' ').without('')

    # shift off the first part to use for identifying what command we have
    command = args.shift()

    # Determine which command we are running
    switch command
      when "/connect"
        @_connect(args[0])
      when "/disconnect"
        @_disconnect()
      when "/nick"
        @_setNick(args[0])

  # Sends a message to our current channel
  _message: (message) ->
    @get('_fayeClient').publish("/chatroom", message: message)

  # Connects to our server
  _connect: (server) ->
    if !@get('isConnected') && server?
      client = new Faye.Client("http://#{server}:9292/faye")
      # This is where error handling would go
      client.subscribe("/chatroom", @_messageReceived)
      @set('_fayeClient', client)
      @set('isConnected', true)

  # Disconnects from our server
  _disconnect: ->
    if @get('isConnected')
      @set('isConnected', false)
      @get('_fayeClient').disconnect()


  ###
  # Server Events
  ###    
  _messageReceived: (message) ->
    console.log message
