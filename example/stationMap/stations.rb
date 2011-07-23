require 'rubygems'
require 'sinatra'
require 'haml'
require 'mongo'
require 'json'

require '../noaa_ruby'

get '/' do
  temps = NOAA.current_weather(19106)
  @temps = temps
  haml :index
end

get '/map' do
  @jquery_script = "https://ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js"
  @google_script = "http://maps.google.com/maps/api/js?sensor=true"  
  haml :map
end

get '/weather/:zip' do
  zip = params['zip'].to_i
  data = NOAA.current_weather(zip)

  temp = data[:temp]
  return temp

  #db = Mongo::Connection.new.db("stationMap")
  #stations = db["weatherStations"]

  #station_id = stations
  #  .find(
  #    {'loc' => { '$near' => [data[:lat], data[:lng]]}}, 
  #    {:limit => 1})
  #  .map { |station| station["ICAOIndicator"] }
  #  .first

  #return NOAA.history_weather(station_id).to_s
end

get '/stations' do
  db = Mongo::Connection.new.db("stationMap")
  stations = db["weatherStations"]

  lat = params[:lat].to_f
  lng = params[:lng].to_f
  station_arr = stations.find(
    {'loc' => { '$near' => [lat,lng]}}, 
    {:limit => 100}
  ).map { | station | {
      :name => station["placeName"],
      :code => station["ICAOIndicator"],
      :location => {
        :lat => station["loc"]["lat"],
        :lng => station["loc"]["lng"]
       }
    }
  }
  puts station_arr
  content_type :json
  return station_arr.to_json
end
