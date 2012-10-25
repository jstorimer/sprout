# Slightly more complex chat thing

class Chatting
  def initialize
    @users = []
  end

  def setup(server)
    server.on(:accept) do |client|
      register_client(client)
    end

    def register_client
      @users << client

      client.on(:data) do |data|
        send_update(data)
      end

      client.on(:close) do
        @users.delete(client)
      end

      send_update "New user joined!"
    end

    def send_update(update)
      @users.each do |client|
        client.write update
      end
    end
  end
end

reactor = Sprout::Reactor.new

chat = Chatting.new
chat.setup(reactor.listen('0.0.0.0', 4481))

reactor.start

