
# This is going to be used for setting the content on our controllers
App.ApplicationRoute = Em.Route.extend

  setupController: (controller) ->
    @controllerFor('userList').set('content', App.User.all())