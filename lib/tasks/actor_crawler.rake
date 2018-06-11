namespace :crawler do
  desc 'Download all actors'
  task :actor => :environment do
    get_all_actors()
  end

  desc 'Get all javbus actors labels'
  task :javbus_label => :environment do
    get_all_actors_label_from_javbus()
  end

  desc 'Format all javbus labels(remove "nowprinting.gif")'
  task :javbus_label_format => :environment do
    format_javbus_labels()
  end
end

# --- Method ---
def get_all_actors
  first_url = "#{$JAVLIBRARY_URL}/cn/star_list.php?prefix="

  'A'.upto('Z') do |alphabet|
    response = Mechanize.new
    # response.log = Logger.new 'http_log'
    # response.user_agent_alias = 'Mac Safari'

    tempurl = first_url + alphabet

    Rails.logger.info "get_all_actors: tempurl=> " + "  #{tempurl} ".green

    response.get tempurl

    doc = Nokogiri::HTML(response.page.body)
    last_page = author_page_num(doc)

    Rails.logger.info "get_all_actors: last_page => " + " #{last_page} ".green

    1.upto(last_page) do |page_num|
      temp_page_url = tempurl + "&page=#{page_num.to_s}"

      Rails.logger.info "get_all_actors: temp_page_url => "+ " #{temp_page_url} ".green

      response.get temp_page_url

      doc_page = Nokogiri::HTML(response.page.body)
      doc_page.search('//div[@class="starbox"]/div[@class="searchitem"]/a').each do |row|

        Rails.logger.info "get_all_actors: get_row  => " + " #{row} ".green

        # row.text Actor.name
        # row['href'].split("=")[-1] Actor.label
        name = row.text; label = row['href'].split("=")[-1]
        actor = Actor.new
        actor.name = name
        actor.actor_label = label
        actor.actor_type = alphabet
        actor.save
      end
    end
  end
end

def author_page_num(nokogiri_doc)
  last_page = 1
  nokogiri_doc.search('//div[@class="page_selector"]/a[@class="page last"]').each do |row|
      last_page = row['href'].split("=")[-1].to_i
  end
  last_page
end

# Max page https://www.javbus2.pw/actresses/717
JAVBUS_MAX_PAGE = 745

def get_all_actors_label_from_javbus
  page = Mechanize.new
  first_url = "#{$JAVBUS_URL}/actresses/"
  #1.upto(JAVBUS_MAX_PAGE).each do |num|
  1.upto(JAVBUS_MAX_PAGE).each do |num|
    url = first_url + num.to_s
    doc = Nokogiri::HTML(page.get(url).body)
    doc.search('//div[@id="waterfall"]/div/a/div[1]/img').each do |item|
      label = item.attributes['src'].value.split('/')[-1].split('_')[0]
      name = item.attributes['title'].value.split('（')[0].strip

      next if label == "nowprinting.gif"

      actor = Actor.where('name = ?', name).first
      next if actor == nil

      actor.javbus_label = label
      actor.save
    end
  end
end

def format_javbus_labels
  Actor.all.each do |actor|
    if actor.javbus_label == "nowprinting.gif"
      actor.javbus_label = nil
      actor.save
    end
  end
end
