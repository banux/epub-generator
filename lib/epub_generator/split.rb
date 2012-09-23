require 'cgi'

module EpubGenerator
	class Split

		def initialize(config)
			@new_array = []
			config.html.each do |file|
				new_htmls = split_file(file)
				@new_array << new_htmls
			end			
		end

		def get_html_list
			return @new_array
		end

		def split_file(file)
			original_html = Nokogiri::HTML(open(file))
			html_attributes = original_html.at_css('html').attributes
			head = original_html.at_css 'head'
			body = original_html.at_css('body')			
			body_attributes = body.attributes
			puts body_attributes.inspect
			body_attributes_arr = []
			body_attributes.each do |key, value|
				body_attributes_arr << key + "=" + value
			end
			body_attributes_str = body_attributes_arr.join(" ")
			doctype = original_html.internal_subset

			#TODO : ne pas incorpore les br
			@chapters = original_html.xpath('//body').children.inject([{:title => '', :contents => '', :type => 'body'}]) do |chapters_hash, child|
			  if child.name == 'h1' || child.name == 'h2' || (child.name == "br" && child.attr('class') == 'chapter_break')
			    title = child.inner_text
			    type = child.name
			    chapters_hash << { :title => title, :contents => '', :type => type}
			  end

			  next chapters_hash if chapters_hash.empty?
			  chapters_hash.last[:contents] << child.to_xhtml
			  chapters_hash
			end

			first = true
			i = 1
			file_list = []
			@chapters.each do |chap|
				if first
					filename = "cover.xhtml"
					first = false
				else
					filename = "File" + i.to_s + ".xhtml"
					i += 1
				end
				xhtml_file = File.open(filename, "w+")
				xhtml_file.puts '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http&nbsp;://www.w3.org/TR/html4/loose.dtd">'
				xhtml_file.puts "<html>"
				xhtml_file.puts head
				xhtml_file.puts "<body " + body_attributes_str + ">"
				xhtml_file.puts chap[:contents]
				xhtml_file.puts "</body></html>"
				xhtml_file.close
				puts "write " + filename
				file_list << filename
			end
			return file_list
		end

	end
end