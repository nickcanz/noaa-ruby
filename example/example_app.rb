require 'rubygems'
require 'sinatra'

require '../noaa_ruby'

get '/' do
  'Hi There'
end

get '/weather/:zip' do
  #"weather for #{params[:zip]}"
  current_weather params[:zip]
  #Noaa::DSL.current_weather params[:zip]
end
