require 'nokogiri'
require 'open-uri'
require 'set'

class WebCrawler
  attr_accessor :base_url, :categories

  def initialize(base_url)
    @base_url = base_url
    @categories = {}
  end

  def crawl!
    html_content = open(base_url).read
    parsed_content = Nokogiri::HTML(html_content)

    # Traverse the structure
    parsed_content.css('div.colored-links').each do |div|
      category_name = div.css('p strong').first.text

      # For each <a> tag under the category, get the href and form an absolute URL
      links = div.css('p')[1..-1].map do |p|
        p.css('a').map { |a| "#{base_url}#{a['href']}" }
      end.flatten

      categories[category_name] = links
    end
  end
end

# Usage:
crawler = WebCrawler.new('http://spheres5e.wikidot.com/spheres-of-power')
crawler.crawl!
puts crawler.categories
