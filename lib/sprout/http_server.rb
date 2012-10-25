require 'rack'
require 'http_tools'

module Sprout
  class HttpServer
    def initialize(ru_file)
      @app, _ = Rack::Builder.parse_file ru_file
    end

    def setup(listener)
      listener.on(:accept) do |client|
        parser = HTTPTools::Parser.new

        parser.on(:finish) do
          status, headers, body = @app.call(parser.env)
          # [200, {'Content-Type' => 'text/plain'}, ['ohai']]

          keep_alive = parser.header['Connection'] != 'close' && parser.header['Content-Length']
          headers['Connection'] = keep_alive ? 'Keep-Alive' : 'Close'

          client.write(HTTPTools::Builder.response(status, headers))
          body.each do |chunk|
            client.write(chunk)
          end

          body.close if body.respond_to?(:close)
          client.close unless keep_alive
        end

        client.on(:data) do |data|
          parser.reset if parser.finished?
          parser << data
        end
      end
    end
  end
end
