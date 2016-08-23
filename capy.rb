require 'capybara'
require 'capybara/poltergeist'
require 'csv'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false)
end

Capybara.default_driver = :poltergeist

browser = Capybara.current_session




 isbnArray  = '1405232501 082172388X 0764222228
              0590474235 0672320835 0439539439
              0375434461 0752859978 0752860224
              2745945475 0425032337 074459040X
              1860393225 1405232501 082172388X
              0764290762 0590474235 0672320835
              3826672429 0375434461 0752859978
              038079392X 2745945475 0425032337
              0701184361 1860393225 0758238614
              0152049215 3826672429 1921656573
              0747203873 0701184361 0764222228
              0439539439 0152049215 0752860224
              074459040X 0747203873 0764290762
              038079392X 1921656573 0758238614'
csvRows = []
newArray = isbnArray.split(" ")
newArray.each do |a|
  #goes to first isbn amazon search
  url = "https://www.amazon.com/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords=#{a}"
  browser.visit url
  puts browser.current_url

  #gets first link and clicks it
  link = browser.first('#result_0 a')
  link.click
  puts browser.current_url

  #gets the name and other title things with indented tests
  name = "Name: #{browser.find('#productTitle').text}"
  begin
    author = "Author: #{browser.find('.author').text}"
  rescue
    puts "error occured"
    author = "Author: N/A"
  end
  isbn10 = "ISBN-10: #{browser.find("li", :text => "ISBN-10").text.split(/: /)[1]}"
  isbn13 = "ISBN-13: #{browser.find("li", :text => "ISBN-13").text.split(/: /)[1]}"
  publisher = "Publisher: #{browser.find("li", :text => "Publisher").text.split(/: | \(|;/)[1]}"


csvRows << [name, author, publisher, isbn10, isbn13]

end

CSV.open('books.csv', 'wb') do |csv|
  csvRows.each do |csvRow|
    csv << csvRow
  end
end