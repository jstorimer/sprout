require_relative '../lib/sprout/reactor'
require_relative '../lib/sprout/redis'

reactor = Sprout::Reactor.new
server = reactor.listen '0.0.0.0', 3030

server.on(:accept) do |client|
  client.on(:data) do |data|
    socket = reactor.connect '127.0.0.1', 6379
    redis = Sprout::Redis.new(socket)

    redis.blpop(data.strip, 3) do |reply|
      client.write reply.to_s
      client.close
    end
  end
end

reactor.start

