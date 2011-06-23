require 'rubygems'
require 'nokogiri'
require 'rest_client'
require 'date'

module NoaaRuby
  module DSL
    WEATHER_URL = 'http://www.weather.gov/forecasts/xml/sample_products/browser_interface/ndfdXMLclient.php'

    def current_weather(*args)
      response = RestClient.get WEATHER_URL, {
        :params => {
          :zipCodeList => args[0],
          :product => 'time-series',
          :begin => DateTime.now.to_s,
          :end => (DateTime.now + 1).to_s,
          :appt => 'appt',
        }
      }

      parsed_resp = Nokogiri::XML(response)
      current_temp = parsed_resp.at_css("temperature[type=apparent] value").content
      return current_temp
    end
  end
end

self.extend NoaaRuby::DSL
