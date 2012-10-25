require 'events'

module Sprout
  Server = Struct.new(:socket) do
    include Events::Emitter

    def handle_read
      begin
        client = socket.accept_nonblock
        emit(:accept, Stream.new(client))
      rescue Errno::EAGAIN
      end
    end
    
    def to_io
      socket
    end
  end
end
