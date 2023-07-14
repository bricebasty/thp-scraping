# frozen_string_literal : true

require 'nokogiri'
require 'open-uri'

def scrape_cmc
  # On utilise Nokogiri pour analyser le contenu HTML de la page web
  page = Nokogiri::HTML(URI.open("https://coinmarketcap.com/all/views/all/"))

  # On extrait les noms des cryptomonnaies à partir du HTML analysé
  names = page.xpath('/html/body/div[1]/div[2]/div[2]/div/div[1]/div/div[2]/div[3]/div/table/tbody/tr/td[2]/div/a[1]')
              .map { _1.text }

  # On extrait les prix des cryptomonnaies à partir du HTML analysé
  prices =  page.xpath('/html/body/div[1]/div[2]/div[2]/div/div[1]/div/div[2]/div[3]/div/table/tbody/tr/td[5]/div/a/span')
                .map { _1.text.slice(1..-1).delete(',').to_f }

  # On affiche un hash contenant les noms et les prix des cryptomonnaies
  puts names.zip(prices).map { |key, value| { key => value } }

  # On retourne le même hash contenant les noms et les prix des cryptomonnaies
  names.zip(prices).map { |key, value| { key => value } }
end

# On appelle la méthode scrape_cmc pour exécuter le scraping
scrape_cmc
