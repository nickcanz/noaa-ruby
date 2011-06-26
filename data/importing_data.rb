require 'mongo'
require 'csv'

def convert_latlon(deg_str)
  arr = deg_str.split("-")
  deg = arr[0].to_f
  
  mins = 0
  secs = 0
  hemi_str = ''

  # DD-MMH = degs, mins, hemisphere
  # or 
  # DD-MM-SSH = degs, mins, secs, hemisphere
  if(arr.length == 2) 
    mins = arr[1].slice(0, arr[1].length-1).to_f * 60
    hemi_str = arr[1].slice(-1)
  elsif (arr.length == 3) 
    mins = arr[1].to_f
    secs = arr[2].slice(0, arr[2].length-1).to_f
    hemi_str = arr[2].slice(-1)
  end

  hemisphere = (hemi_str == "N" || hemi_str == "E") ? 1 : -1

  deg_dec = deg + ((mins+secs) / 3600)
  deg_dec * hemisphere
end

db = Mongo::Connection.new.db("stationMap")
stations = db["weatherStations"]

CSV.foreach("weather_stations.txt", { :col_sep => ';'}) do |row|
  station = {
    "ICAOIndicator" => row[0],
    "placeName"     => row[3],
    "loc" => {
      "lat" => convert_latlon(row[7]),
      "lon" => convert_latlon(row[8])
    }
  }
stations.insert(station)
end
