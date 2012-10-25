require 'events'

module Sprout
  class Stream
    attr_accessor :io

    def initialize(io)
      @io = io
      @write_buffer = ""
    end

    include Events::Emitter
    CHUNK_SIZE = 8 * 1024

    def handle_read
      begin
        data = io.read_nonblock(CHUNK_SIZE)
        emit(:data, data)
      rescue IO::WaitReadable
      rescue EOFError
        close if io.closed?
      end
    end

    def handle_write
      return if @write_buffer.empty?
      write(@write_buffer)
    end

    def write(data)
      begin
        bytes = io.write_nonblock(data)
        @write_buffer = data.slice(bytes, data.size)
      rescue Errno::EAGAIN, Errno::EPIPE
      end
    end

    def close
      emit(:close)
      io.close
    end

    def to_io
      io
    end
  end
end

