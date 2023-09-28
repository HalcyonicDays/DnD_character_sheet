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

      # Gather all <a> tags under the category until we hit an <hr> or another <p><strong>...</strong></p>
      current = div.css('p strong').first.parent.next_sibling # start right after the category <p>
      links = []
      while current && !current.name.eql?('hr') && (!current.name.eql?('p') || !current.at('strong'))
        if current.name.eql?('a') || (current.name.eql?('p') && current.at('a'))
          links.concat(current.css('a').map { |a| "#{base_url}#{a['href']}" })
        end
        current = current.next_sibling
      end

      categories[category_name] = links
    end
  end
end

# Usage:
crawler = WebCrawler.new('http://spheres5e.wikidot.com/spheres-of-power')
crawler.crawl!
puts crawler.categories
