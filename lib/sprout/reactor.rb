require 'socket'
require 'thread'

require_relative './server'
require_relative './stream'

module Sprout
  class Reactor
    def initialize
      @streams = []
    end

    def listen(host, port)
      socket = TCPServer.new(host, port)
      socket.listen(Socket::SOMAXCONN)
      server = Server.new(socket)

      register(server)

      server.on(:accept) do |client|
        register(client)
      end

      server
    end

    def connect(host, port)
      socket = TCPSocket.new(host, port)
      stream = Stream.new(socket)
      register(stream)

      stream
    end

    def register(stream)
      @streams << stream

      stream.on(:close) do
        @streams.delete(stream)
      end
    end

    def start(blocking = true)
      if blocking
        loop { tick }
      else
        Thread.abort_on_exception = true
        Thread.new do
          loop { tick }
        end
      end
    end

    def tick
      readable, _ = IO.select(@streams)

      readable.each do |stream|
        stream.handle_read
      end
    end
  end
end

