require_relative '../lib/sprout/reactor'

# Simple echo service
reactor = Sprout::Reactor.new

# Get a server instance
server = reactor.listen '0.0.0.0', 4481

server.on(:accept) do |client|
  client.on(:data) do |data|
    client.write data
    client.close
  end
end

reactor.start

