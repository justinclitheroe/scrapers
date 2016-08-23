require 'capybara'
require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false)
end

Capybara.default_driver = :poltergeist

browser = Capybara.current_session

url = "http://www.loyola.edu/events"

browser.visit url


browser.within_frame('trumba.spud.1.iframe') do
  rows = browser.all('tr')
  arrayTest = []
  rows.each do |row|
    arrayTest << "#{row.text}"
  end
  puts "succ"

  require 'pry'
  binding.pry

end

# require 'pry'
# binding.pry
