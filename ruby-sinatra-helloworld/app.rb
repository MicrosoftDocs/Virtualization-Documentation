# app.rb
# simple hello world web app

require 'sinatra'

get '/' do
  "Hello, world!"
end
