require 'open-uri'
require 'rubygems'
require 'nokogiri'
require 'rest_client'
require 'date'

module NOAA
  WEATHER_URL = 'http://www.weather.gov/forecasts/xml/sample_products/browser_interface/ndfdXMLclient.php'

  def current_weather(zip)
    response = RestClient.get WEATHER_URL, {
      :params => {
        :zipCodeList  => zip,
        :product      => 'time-series',
        :begin        => DateTime.now.to_s,
        :end          => (DateTime.now + 1).to_s,
        :appt         => 'appt',
      }
    }

    parsed_resp = Nokogiri::XML(response)
    current_temp = parsed_resp.at_css("temperature[type=apparent] value").content
    location = parsed_resp.at_css("point")
    return {
      :current_temp => current_temp,
      :lat          => location['latitude'].to_f,
      :lng          => location['longitude'].to_f, 
    }
  end
  module_function :current_weather

  def history_weather(station_code)
    url = "http://www.weather.gov/data/obhistory/#{station_code}.html"
    today = Date.today.day
    yesterday = (Date.today - 1).day

    html_doc = Nokogiri::HTML(open(url))
    table = html_doc.css('table')[3]
    rows = table.css('tr[bgcolor!="#b0c4de"]')
    temps = rows.map do |row|
      td = row.css('td')
      p td.to_xml
      date = td[0].content.to_i
      if date == today || date == yesterday then
        if(td[8].content != '') then
          return {
            :max => td[8].content.to_i,
            :min => td[9].content.to_i,
          }
        end
      end
    end
    return temps
  end
  module_function :history_weather

end
