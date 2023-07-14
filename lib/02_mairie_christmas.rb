# frozen_string_literal : true

require 'nokogiri'
require 'open-uri'

# Définition d'une méthode pour obtenir l'e-mail de la mairie à partir de son URL
def get_townhall_email(townhall_url)
  # Création d'une instance Nokogiri à partir de l'ouverture de l'URL de la mairie
  page = Nokogiri::HTML(URI.open("http://annuaire-des-mairies.com#{townhall_url}"))
  # Extraction du nom de la mairie à partir du chemin XPath spécifié dans la page
  name = page.xpath('/html/body/div[1]/main/section[1]/div/div/div/h1').text.gsub(/[0-9]+/, '').gsub(/[-]?$/, '').gsub(/[-*]/, ' ').strip
  # Extraction de l'adresse e-mail de la mairie à partir du chemin XPath spécifié dans la page
  email = page.xpath('/html/body/div[1]/main/section[2]/div/table/tbody/tr[4]/td[2]').text
  # Création d'un hash avec le nom de la mairie comme clé et l'adresse e-mail comme valeur
  hash = { name => email }
end

# Définition d'une méthode pour obtenir les URLs de toutes les mairies d'un département
def get_townhall_urls
  # Création d'une instance Nokogiri à partir de l'ouverture de l'URL du département
  department_url = Nokogiri::HTML(URI.open("http://annuaire-des-mairies.com/val-d-oise.html"))

  # Extraction de toutes les URLs des mairies à partir de la classe CSS 'lientxt' dans la page
  all_urls = department_url.css('.lientxt').map do |e|
    # Appel de la méthode get_townhall_email pour obtenir l'e-mail de chaque mairie
    get_townhall_email(e.attr('href').slice(1..-1))
  end

  # Affichage de toutes les URLs des mairies
  puts all_urls
end

# Appel de la méthode get_townhall_urls pour obtenir les URLs des mairies d'un département
get_townhall_urls
