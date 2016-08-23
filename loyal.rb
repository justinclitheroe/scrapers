require 'capybara/poltergeist'
require 'date'
require 'nokogiri'

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
  # divs = browser.all('tr td div')
  # rows = browser.all('tr')
  #
  # eventName = nil
  # eventDate = nil
  # eventYear = nil
  # eventTime = nil
  # eventDesc = nil
  # eventLocn = nil
  #
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
        eventDate = nil
      end

      if row.at_css('.twDetailListLocationLine')
        eventLocation = row.at_css('.twDetailListLocationLine').content
      else
        eventLocation = nil
      end

      if row.at_css('.twDetailListNotes')
        eventDesc = row.at_css('.twDetailListNotes').content
      else
        eventDesc = nil
      end
    elsif row.at_css('.twDetailListItem')
      puts "Passed: end of event line"

      #puts the information into an array
      infoArray << [eventTitle, eventDate, eventLocation, eventDesc]
    elsif row.at_css('.twDetailListGroupHead')
      year = row.at_css('.twDetailListGroupHead').content

    end
  end

  infoArray.each do |info|
    puts info
  end


  # rows.each do |row|
  #   browser.within(row) do
  #      if (browser.has_css?('td .twDetailListHeader'))
  #        puts "this is the fucking title"
  #      elsif (browser.has_css?('.twContentCell'))
  #        puts "this is the date/description/location"
  #      elsif (browser.has_css?('td .twDetailListItem'))
  #        puts "this is the end of the block"
  #      elsif (browser.has_css?('td .twDetailListGroupHead'))
  #        puts "this is the year row"
  #
  #      end
  #   end
  # end



  # divs.each do |div|
  #   puts "#{div['class']}: #{div.text}"
  # end
  # puts "succ"

  require 'pry'
  binding.pry

end

# require 'pry'
# binding.pry
