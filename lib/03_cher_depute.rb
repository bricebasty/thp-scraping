# frozen_string_literal : true

require 'nokogiri'
require 'open-uri'

MAX_RETRIES = 3
RETRY_DELAY = 60

def get_deputy_info(deputy_url)
  retries = 0

  loop do
    begin
      # Ouvrir la page du député à l'aide de Nokogiri
      page = Nokogiri::HTML(URI.open("https://www2.assemblee-nationale.fr#{deputy_url}"))

      # Extraire les parties du nom du député
      name_parts = page.at_xpath('/html/body/div[1]/main/div/div/div/section[1]/div/div[1]/a[1]/h1').text.gsub(/(M\. |Mme )/, '').split

      # Extraire l'adresse e-mail du député
      email = page.at_xpath('/html/body/div[1]/main/div/div/div/section[2]/div/ul/li[1]/a/span[2]').text

      # Créer un hash avec les informations du député
      deputy_hash = {
        "first_name" => name_parts[0],
        "last_name" => name_parts[1..-1].join(' '),
        "email" => email
      }

      # Afficher le hash du député
      puts deputy_hash
      return deputy_hash
    rescue OpenURI::HTTPError, Net::OpenTimeout => e
      # En cas d'erreur HTTP ou de délai d'ouverture de connexion, gérer les tentatives de nouveau
      if retries < MAX_RETRIES
        retries += 1
        puts "Rencontre une erreur 504 Gateway Timeout. Nouvelle tentative dans #{RETRY_DELAY} secondes..."
        sleep RETRY_DELAY
      else
        puts "Échec de la récupération des informations du député : #{e}"
        return nil
      end
    end
  end
end

def get_deputy_urls
  # Ouvrir la page de la liste des députés à l'aide de Nokogiri
  deputy_url = Nokogiri::HTML(URI.open("https://www2.assemblee-nationale.fr/deputes/liste/alphabetique"))

  # Extraire tous les URL des députés et récupérer leurs informations
  all_urls = deputy_url.xpath('/html/body/div[1]/div[2]/div/div/section/div/article/div[3]/div/div[3]/div/ul/li/a').map { |e| get_deputy_info(e.attr('href')) }

  # Afficher tous les URL et leurs informations
  puts all_urls
end

# Appeler la méthode pour obtenir les URL des députés et leurs informations
get_deputy_urls
