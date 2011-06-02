require 'mongo'
require 'csv'

def convert_latlon(deg_str)
  # DD-MMH = degs, mins, hemisphere(N/S)
  arr = deg_str.split("-")
  deg = arr[0].to_f
  mins = arr[1].slice(0, arr[1].length-1).to_f * 60
  hemi_str = arr[1].slice(-1)
  hemisphere = (hemi_str == "N" || hemi_str == "E") ? 1 : -1

  deg_dec = deg + (mins / 3600)
  deg_dec * hemisphere
end

db = Mongo::Connection.new.db("mydb")
stations = db["weatherStations"]

count = 1

CSV.foreach("weather_stations.txt", { :col_sep => ';'}) do |row|
  station = {
    "ICAOIndicator" => row[0],
    "placeName"     => row[3],
    "loc" => {
      "lat" => convert_latlon(row[7]),
      "lon" => convert_latlon(row[8])
    }
  }
  count += 1
  p count
end
