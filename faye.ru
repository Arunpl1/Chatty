require 'faye'
require 'pry'

# This is used for serving up our requests
Faye::WebSocket.load_adapter('thin')


# For the sake of demonstration, i'm defining our faye irc server extension here
class FayeIrcExtension
  @clients = {}

  def incoming(message, callback)
    callback.call(message)
  end

end

# This is used for creating a new server instance
faye_server = Faye::RackAdapter.new(
  mount: '/faye', 
  timeout: 45,
  extensions: [FayeIrcExtension.new]
)
run faye_server