use Rack::ContentLength
run lambda { |env|
  [200, {'Content-Type' => 'text/plain'}, ['ohai']]
}

