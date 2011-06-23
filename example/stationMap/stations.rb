require 'rubygems'
require 'sinatra'
require 'haml'

get '/' do
  @jquery_script = "https://ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js"
  @google_script = "http://maps.google.com/maps/api/js?sensor=true"  
  haml :index
end
