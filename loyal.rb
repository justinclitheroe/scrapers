require 'capybara/poltergeist'
require 'date'
require 'nokogiri'
require 'csv'

#loads poltergeist as a driver
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false)
end

#sets poltergeist as the default to be used
Capybara.default_driver = :poltergeist

#everything is easier with shorthand
browser = Capybara.current_session

#off to loyola's event page (a million curses upon its head)
browser.visit "http://www.loyola.edu/events"

#testing
puts "page loaded"

#puts the browser in focus of the iframe
#an
#
browser.within_frame('trumba.spud.1.iframe') do

  page = Nokogiri::HTML(browser.source)
  rows = page.css('tr')

  eventDate, eventTime, eventTitle, eventLocation, eventDesc = nil
  year = nil

  infoArray = []

  rows.each do |row|
    if row.at_css('.twDetailListHeader')
      eventTitle = row.at_css('a').content
    elsif row.at_css('.twContentCell')
      if row.at_css('.twDetailListDateLine')
        eventDate = row.at_css('.twDetailListDateLine').content
      else
        eventDate = "N/A"
      end

      if row.at_css('.twDetailListLocationLine')
        eventLocation = row.at_css('.twDetailListLocationLine').content
      else
        eventLocation = "N/A"
      end

      if row.at_css('.twDetailListNotes')
        eventDesc = row.at_css('.twDetailListNotes').content
      else
        eventDesc = "N/A"
      end
    elsif row.at_css('.twDetailListItem')
      puts "Passed: end of event line"

      #puts the information into an array
      infoArray << ["#{eventTitle}", "#{eventDate}", "#{eventLocation}", "#{eventDesc}"]
    elsif row.at_css('.twDetailListGroupHead')
      year = row.at_css('.twDetailListGroupHead').content

    end
  end

CSV.open("loyolaData.csv", "w") do |csv|
  infoArray.each do |info|
  	csv << info
  end
end

  # require 'pry'
  # binding.pry

end

# require 'pry'
# binding.pry
