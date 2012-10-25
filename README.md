# Sprout

Sprout is an evented IO system written in pure Ruby. Sprout provies a single-threaded Reactor capable of processing many streams/connections concurrently.

# Usage

``` ruby
# Simple echo service
reactor = Sprout::Reactor.new

# Get a server instance
server = reactor.listen '0.0.0.0', 4481

server.on(:accept) do |client|
  client.on(:data) do |data|
    client.write data
  end
end

reactor.start
```

For more examples see the `examples/` directory.

# Origin

This library was created as part of the video for [Working With TCP Sockets](http://workingwithtcpsockets.com). 

# Prior Art

Sprout borrows a lot of ideas from other evented systems.

* <https://gist.github.com/3612925>
* [Reactor](https://github.com/oldmoe/reactor)
* [EventMachine](http://rubyeventmachine.com/)
* [node.js](http://nodejs.org/)

# License

MIT

