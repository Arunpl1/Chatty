# This is used to handle new messages sent from the command bar
# In theory, this would be it's own "network controller", but for demonstration sake
# I am putting it all inside of the commandbar controller

kJoinCommand = 'join'
kPartCommand = 'part'

App.CommandBarController = Ember.Controller.extend
  
  # This is used for our connection state -- locks opening multiple connections
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
    @get('_fayeClient').publish("/chatroom", message: message) if @get('isConnected')

  # Connects to our server
  _connect: (server) ->
    if !@get('isConnected') && server?
      client = new Faye.Client("http://#{server}:9292/faye")

      # We want to subscribe to chatroom and server events
      client.subscribe("/chatroom", @_messageReceived.call(@))
      client.subscribe('/event', @_serverEvent.bind(@))

      # Announce that we've just joined
      client.publish('/event', type: kJoinCommand)

      # Hold on to our client for subsequent requests
      @set('_fayeClient', client)
      @set('isConnected', true)

  # Disconnects from our server
  _disconnect: ->
    client = @get('_fayeClient')

    if @get('isConnected')
      client.publish('/event', type: kPartCommand)
      client.disconnect()
      @set('isConnected', false)

  ###
  # Server Events
  ###    

  # There's a message for our chatroom 
  _messageReceived: (message) ->
    console.log message

  # There's an event that happened (such as nickname change, joining channel, leaving, etc..)
  _serverEvent: (message) ->
    store = @get('store')
    adapter = store.adapterForType(App.User)

    switch message.type
      # When a user joins our chat channel
      when "join"
        adapter.load(store, App.User, message.user)

      # When a user parts our chat channel
      when "part"
        user = App.User.find(message.user.id)
        store.unloadRecord(user)

    console.log message