require 'faye'
require 'pry'

# This is used for serving up our requests
Faye::WebSocket.load_adapter('thin')


# For the sake of demonstration, i'm defining our faye irc server extension here
# I will not be commenting this code because it shouldn't be used.
class FayeIrcExtension
  @clients = {}

  def incoming(message, callback)

  if message['data']
    message['data']['user'] = {}
    message['data']['user']['id'] = message['clientId']
    message['data']['user']['name'] = randomName
  end

    callback.call(message)
  end

  private

  def randomName
    "Guest#{rand(10000)}"
  end

end

# This is used for creating a new server instance
faye_server = Faye::RackAdapter.new(
  mount: '/faye', 
  timeout: 45,
  extensions: [FayeIrcExtension.new]
)
run faye_server