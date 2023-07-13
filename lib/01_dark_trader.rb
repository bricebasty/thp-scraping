# frozen_string_literal : true

require 'nokogiri'
require 'open-uri'

def scrape_cmc
  page = Nokogiri::HTML(URI.open("https://coinmarketcap.com/all/views/all/"))
  names = page.xpath('/html/body/div[1]/div[2]/div[2]/div/div[1]/div/div[2]/div[3]/div/table/tbody/tr/td[2]/div/a[1]')
              .map { _1.text }
  prices =  page.xpath('/html/body/div[1]/div[2]/div[2]/div/div[1]/div/div[2]/div[3]/div/table/tbody/tr/td[5]/div/a/span')
                .map { _1.text.slice(1..-1).delete(',').to_f }
  puts names.zip(prices).map { |key, value| { key => value } }
  names.zip(prices).map { |key, value| { key => value } }
end

scrape_cmc