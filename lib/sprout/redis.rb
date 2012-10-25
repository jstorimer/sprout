require 'hiredis/reader'

module Sprout
  class Redis

    CRLF = "\r\n".freeze

    def initialize(client)
      @reader = Hiredis::Reader.new
      @callbacks = []

      @client = client

      @client.on(:data) do |data|
        @reader.feed(data)

        until (reply = @reader.gets) == false
          receive_reply(reply)
        end
      end
    end

    def receive_reply(reply)
      callback = @callbacks.shift
      callback.call(reply) if callback
    end

    def send_command(*args)
      args = args.flatten
      @client.write("*" + args.size.to_s + CRLF)
      args.each do |arg|
        arg = arg.to_s
        @client.write("$" + arg.size.to_s + CRLF + arg + CRLF)
      end
    end

    def method_missing(sym, *args, &callback)
      send_command(sym, *args)
      @callbacks.push callback
    end
  end
end

