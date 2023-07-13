# frozen_string_literal : true

require 'nokogiri'
require 'open-uri'

def get_townhall_email(townhall_url)
  page = Nokogiri::HTML(URI.open("http://annuaire-des-mairies.com#{townhall_url}"))
  name = page.xpath('/html/body/div[1]/main/section[1]/div/div/div/h1').text.gsub(/[0-9]+/, '').gsub(/[-]?$/, '').gsub(/[-*]/, ' ').strip
  email = page.xpath('/html/body/div[1]/main/section[2]/div/table/tbody/tr[4]/td[2]').text
  hash = { name => email }
end

def get_townhall_urls
  department_url = Nokogiri::HTML(URI.open("http://annuaire-des-mairies.com/val-d-oise.html"))

  all_urls = department_url.css('.lientxt').map do |e|
    get_townhall_email(e.attr('href').slice(1..-1))
  end

  puts all_urls
end

get_townhall_urls