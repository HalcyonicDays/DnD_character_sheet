require 'nokogiri'
require 'open-uri'
require 'set'

class WebCrawler
  attr_accessor :base_url, :visited_links, :pending_links

  def initialize(base_url)
    @base_url = base_url
    @visited_links = Set.new
    @pending_links = [base_url]
  end

  def crawl!
    while link = @pending_links.pop
      next if @visited_links.include?(link)

      @visited_links.add(link)

      begin
        html_content = open(link).read
        parsed_content = Nokogiri::HTML(html_content)

        parsed_content.css('a').each do |a_tag|
          href = a_tag['href']

          # Skip if href is nil or empty
          next if href.nil? || href.strip.empty?

          # Build an absolute URL if necessary
          if href.start_with?('/')
            href = "#{base_url}#{href}"
          end

          @pending_links << href unless @visited_links.include?(href)
        end
      rescue => e
        puts "Failed to fetch #{link}: #{e.message}"
      end

      # Print out the link we just visited
      puts "Visited: #{link}"
    end
  end
end

# Usage:
crawler = WebCrawler.new('http://spheres5e.wikidot.com/spheres-of-power')
crawler.crawl!
