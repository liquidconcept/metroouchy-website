require 'net/http'
require 'xmlsimple'

module Application
  class BankDay
    REJECTED_BANK_DAYS_ID = ['4', '202', '48']

    def self.get_bank_days
      cache_file = File.expand_path("../../../cache/#{Date.today.year}-#{Date.today.month}.xml", __FILE__)

      if !File.exist?(cache_file)
        url = "http://daybase.eu/getEvents?year=#{Date.today.year}&pid=2&rid=74&p=1&w=1"
        xml_data = Net::HTTP.get_response(URI.parse(url)).body

        bank_days = XmlSimple.xml_in(xml_data)
        bank_days = bank_days['event']
        bank_days.reject { |bank_day| REJECTED_BANK_DAYS_ID.include?(bank_day['id']) }

        File.open(cache_file,"w+") do |f|
          f << XmlSimple.xml_out({'event' => bank_days})
        end
      else
        xml_data = File.read(cache_file)
        bank_days = XmlSimple.xml_in(xml_data)
        bank_days = bank_days['event']
      end

      bank_days
    end

    def self.is_bank_day?(date)
      bank_days = get_bank_days
      bank_days.select { |b| b['occurrences'].first['occurrence'].first['day'].to_i == date.day && b['occurrences'].first['occurrence'].first['month'].to_i == date.month }.count > 0
    end

  end
end
