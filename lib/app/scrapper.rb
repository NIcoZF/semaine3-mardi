# creation of the "save_as_json" method

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'rspec'


class Scrapper

# method which get the names of
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

  def hash(townhall_names, townhall_email)
   hash_name_email = Hash[townhall_names.zip townhall_email]
   return hash_name_email
 end

# add the json method
  def save_as_json(hash_name_email)
    File.open("/home/nico/semaine3/mardi/db/emails.json","w") do |f|  #
    f.write(hash_name_email.to_json)
    end
  end

  def save_as_spreadsheet(townhall_names, townhall_email)

    # Authenticate a session with your Service Account
    session = GoogleDrive::Session.from_config("config.json")
    # Get the spreadsheet by its title
    ws = session.spreadsheet_by_key("1BVP4hlB5iYoykmwXpodUfwzUnCYt9obPafjYhLMXc70").worksheets[0]

    ws[1, 1] = "Noms des Villes" # add head of first column
		i = 2
		y = 0
		while i < 189 # run until the last item by loop and adding 1 to the index in the array townhall_email
			ws[i, 1] = townhall_names[y]
			i = i+1
			y = y+1
		end
		ws[1, 2] = "E-mails des dites mairie" # add head of the secund column
		i = 2
		y = 0
		while i < 189 # run until the last item by loop and adding 1 to the index in the array townhall_email
			ws[i, 2] = townhall_email[y]
			i = i+1
			y = y+1
		end
		ws.save
	end

# convert the hash_name_email into a csv
  def save_as_csv(hash_name_email)
    CSV.open("/home/nico/semaine3/mardi/db/emails.csv", "w") do |csv|
      hash_name_email.each_pair do |key, value|
        csv << [key, value]
      end
    end
#      CSV.open("/home/nico/semaine3/mardi/db/emails.csv", "wb") {|csv| hash_name_email.to_a.each {|elem| csv << elem} }
  end

# perform function wich run all
  def perform
  	townhall_names = get_townhall_names
  	townhall_url = get_townhall_urls
  	townhall_email = get_townhall_email(townhall_url)
  	hash_name_email= hash(townhall_names, townhall_email)
    #save_as_json(hash_name_email)
    #save_as_spreadsheet(townhall_names, townhall_email)
    save_as_csv(hash_name_email)
  end

end # fin de classe
