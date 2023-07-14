# frozen_string_literal : true

require 'nokogiri'
require 'open-uri'

MAX_RETRIES = 3
RETRY_DELAY = 60

def get_deputy_info(deputy_url)
  retries = 0

  loop do
    begin
      page = Nokogiri::HTML(URI.open("https://www2.assemblee-nationale.fr#{deputy_url}"))
      name_parts = page.at_xpath('/html/body/div[1]/main/div/div/div/section[1]/div/div[1]/a[1]/h1').text.gsub(/(M\. |Mme )/, '').split
      email = page.at_xpath('/html/body/div[1]/main/div/div/div/section[2]/div/ul/li[1]/a/span[2]').text
      deputy_hash = {
        "first_name" => name_parts[0],
        "last_name" => name_parts[1..-1].join(' '),
        "email" => email
      }

      puts deputy_hash
      return deputy_hash
    rescue OpenURI::HTTPError, Net::OpenTimeout => e
      if retries < MAX_RETRIES
        retries += 1
        puts "Encountered a 504 Gateway Timeout. Retrying attempt in #{RETRY_DELAY} seconds..."
        sleep RETRY_DELAY
      else
        puts "Failed to scrape deputy info: #{e}"
        return nil
      end
    end
  end
end

def get_deputy_urls
  deputy_url = Nokogiri::HTML(URI.open("https://www2.assemblee-nationale.fr/deputes/liste/alphabetique"))
  all_urls = deputy_url.xpath('/html/body/div[1]/div[2]/div/div/section/div/article/div[3]/div/div[3]/div/ul/li/a').map { |e| get_deputy_info(e.attr('href')) }
  puts all_urls
end

get_deputy_urls
