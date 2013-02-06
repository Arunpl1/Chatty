# This is used to handle events whenever we press enter inside of our text field area
App.CommandBarView = Ember.TextField.extend
  classNames: ['commandBar']
  placeholder: 'Send message...'  
  # We wrap around this event so that we can send the value to our controller and reset the value in the text field  
  insertNewline: ->
    @get('controller').processMessage(@get('value'))

    # This is a pre4 bug with jQuery 1.9 that is fixed in ember trunk
    # this is what we should be doing
    # @set('value', null)
    # this is what we're actually doing
    $('.commandBar').val(null)
    