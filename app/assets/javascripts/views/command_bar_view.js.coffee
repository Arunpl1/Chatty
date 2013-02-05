# This is used to handle events whenever we press enter inside of our text field area
App.CommandBarView = Ember.TextField.extend
  classNames: ['commandBar']
  
  # We wrap around this event so that we can send the value to our controller and reset the value in the text field  
  insertNewline: ->
    @get('controller').processMessage(@get('value'))
    @set('value','')