require_relative '../lib/sprout/reactor'
require_relative '../lib/sprout/http_server'

# ARGV 0 = location of rackup file
# ARGV 1 = port number

reactor = Sprout::Reactor.new
listener = reactor.listen '0.0.0.0', ARGV[1]

server = Sprout::HttpServer.new(ARGV[0])
server.setup(listener)

reactor.start

