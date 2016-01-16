get '/hello/:name' do
  "Hello, #{params['name']}"
end
