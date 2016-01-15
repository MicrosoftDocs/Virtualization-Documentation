# app.rb
require 'sinatra'

class HelloWorldApp < Sinatra::Base
  get '/' do
    "Hello, world!"
  end
end