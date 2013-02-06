require 'faye'
require 'pry'

# This is used for serving up our requests
Faye::WebSocket.load_adapter('thin')


# For the sake of demonstration, i'm defining our faye irc server extension here
# I will not be commenting this code because it shouldn't be used.
class FayeIrcExtension
  @@clientIdToName = {}

  def incoming(message, callback)
    clientId = message['clientId']

    if message['channel'] == '/event'
      case message['data']['type']
      when 'nick'
        setNameForClientId(clientId, message['data']['name'])
      end
    end

    if message['data']
      message['data']['user'] = {}
      message['data']['user']['id'] = clientId
      message['data']['user']['name'] = nameForClientId(clientId)
    end

    callback.call(message)
  end

  private
  def setNameForClientId(clientId, name)
    @@clientIdToName[clientId] = name
  end

  def nameForClientId(clientId) 
    if !@@clientIdToName[clientId]
      setNameForClientId(clientId,randomName)
    end

    return @@clientIdToName[clientId]
  end

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