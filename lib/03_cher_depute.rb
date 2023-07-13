require 'nokogiri'
require 'open-uri'

# page = Nokogiri::HTML(URI.open("https://www2.assemblee-nationale.fr/deputes/liste/alphabetique"))
# first_name = page.xpath('/html/body/div[1]/div[2]/div/div/section/div/article/div[3]/div/div[3]/div/ul/li/a').text.map { _1.gsub(/(M.|Mme)(\b\w+-\w+\b)$/, '')}
# last_name = page.xpath('/html/body/div[1]/div[2]/div/div/section/div/article/div[3]/div/div[3]/div/ul/li/a').text.gsub(/(\w+)$/, '')
# # email = page.xpath('/html/body/div[1]/main/div/div/div/section[2]/div/ul/li[1]/a/span[2]').text

# print first_name



def get_deputy_info(deputy_url)
  page = Nokogiri::HTML(URI.open("https://www2.assemblee-nationale.fr#{deputy_url}"))
  first_name = page.xpath('/html/body/div[1]/main/div/div/div/section[1]/div/div[1]/a[1]/h1').text.gsub(/(M\.\s|Mme\s)/, '').gsub(/(\s\w+\-\w+$|\s\w+$)/, '')
  puts first_name
  last_name = page.xpath('/html/body/div[1]/main/div/div/div/section[1]/div/div[1]/a[1]/h1').text.gsub(/(\w+)$/, '')
end

def get_deputy_urls
  deputy_url = Nokogiri::HTML(URI.open("https://www2.assemblee-nationale.fr/deputes/liste/alphabetique"))

  all_urls = deputy_url.xpath('/html/body/div[1]/div[2]/div/div/section/div/article/div[3]/div/div[3]/div/ul/li/a').map do |e|
    get_deputy_info(e.attr('href'))
  end
end

get_deputy_urls