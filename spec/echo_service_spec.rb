require 'minitest/autorun'
require 'pathname'

lib = Pathname.new(__FILE__).parent.parent.join('lib')
$LOAD_PATH << lib 

require 'sprout/reactor'

describe 'echo service' do
  it 'works' do
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

    reactor.start(false)

    `echo foo | nc localhost 4481`.strip.must_equal 'foo'
  end
end

