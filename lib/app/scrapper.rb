# creation of the "save_as_json" method

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'rspec'

class Scrapper

  def get_townhall_names
  	townhall_names = []
  	page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))
  	page.xpath("//p/a").each do |name|
  		townhall_names << name.text
  	end
  	return townhall_names
  end

  def get_townhall_urls
  	townhall_url = []
  	page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))
  	page.xpath("//p/a/@href").each do |hall|
  		townhall_url << "http://annuaire-des-mairies.com" + hall.to_str[1..-1]
  	end
  	return townhall_url
  end

  def get_townhall_email(townhall_url)
   townhall_email = []
   townhall_url.each do |url_town|
     page = Nokogiri::HTML(open(url_town))
     page.xpath("/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]").each do |email|
       townhall_email << email.text
     end
   end
   return townhall_email
  end

  def hashes_transformation(townhall_names, townhall_email)
  	array_names_emails = townhall_names.zip(townhall_email)
  	array_of_hashes = []
   	array_names_emails.each {|town| array_of_hashes <<  {town[0] => town[1]}}
   	return array_of_hashes
  end

  def save_as_json(array_of_hashes)
    File.open("/home/nico/semaine3/mardi/db/emails.json","w") do |f|
    f.write(array_of_hashes.to_json)
    end
  end

  def perform
  	townhall_names = get_townhall_names
  	townhall_url = get_townhall_urls
  	townhall_email = get_townhall_email(townhall_url)
  	array_of_hashes = hashes_transformation(townhall_names, townhall_email)
    save_as_json(array_of_hashes)
  end



end # fin de classe
