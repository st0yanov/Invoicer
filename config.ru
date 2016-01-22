require_relative 'app/app'
run Invoicer

map('/auth') { run AuthenticationController }