require 'rubygems'
require 'sinatra'
require 'haml'
require 'mongo'
require 'json'


get '/' do
  @jquery_script = "https://ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js"
  @google_script = "http://maps.google.com/maps/api/js?sensor=true"  
  haml :index
end

get '/stations/:lat/:lon' do

  db = Mongo::Connection.new.db("stationMap")
  stations = db["weatherStations"]

  lat = params[:lat].to_f
  lon = params[:lon].to_f
  station_arr = stations.find(
    {'loc' => { '$near' => [lat,lon]}}, 
    {:limit => 100}
  ).map { | station | {
      :name => station["placeName"],
      :code => station["ICAOIndicator"],
      :location => {
        :lat => station["loc"]["lat"],
        :lon => station["loc"]["lon"]
       }
    }
  }
  puts station_arr
  content_type :json
  return station_arr.to_json
end
