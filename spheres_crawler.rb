require 'nokogiri'
require 'open-uri'
require 'pry'

SPHERES = %w(Alteration Conjuration Creation Dark Death Destruction 
	Divination Enhancement Fate Illusion Life Light Mind Nature 
	Protection Telekinesis Time Universal Warp Weather)

class WebCrawler

	def initialize()
	end


end

class Nokogiri::XML::Element
	def n_next(n)
		n.times {self.next_element}
	end
end

def n_next(node, n)
	n.times {node.next_element}
end

url = 'http://spheres5e.wikidot.com/spheres-of-power'
doc = Nokogiri::HTML(URI.open(url))
sphere_headings = doc.css('strong').select {|node| node.children.text =~ /\w*Spheres$/}.uniq

sphere_headings.each do |node|
	puts node, node.children.text, node.next_element
	binding.pry
end

