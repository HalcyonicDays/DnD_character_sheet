require 'nokogiri'
require 'open-uri'

URL = 'http://spheres5e.wikidot.com/spheres-of-power'

# Open the website and read the content
html_content = open(URL).read
parsed_content = Nokogiri::HTML(html_content)

# Extract titles (change the CSS selectors as needed to capture desired content)
titles = parsed_content.css('title or some specific css selector').map(&:text)

puts titles
