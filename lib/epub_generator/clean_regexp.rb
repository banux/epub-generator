
module EpubGenerator
	class CleanRegexp

		def initialize()
			@@regexp_list ||= []
			if @@regexp_list.empty?
				load_regexp
			end			
		end

		def list_regexp
			@@regexp_list.each do |r|
				puts r[:title] + ' : ' + r[:description]				
			end
		end

		def load_regexp
			Dir[File.join(File.dirname(__FILE__), "../../data/regexp", "*.regexp")].each do |file|
				@@regexp_list.push(parse(file))
			end
		end

		def parse(file)
			lines = File.open(file).readlines
			title = lines[0].strip
			description = lines[1].strip
			regexps = []
			i = 2
			while i < lines.size
				search_str = lines[i]
				i = i + 1
				replace_str = lines[i]
				i = i + 1
				regexps.push({:search_str => search_str, :replace_str => replace_str})
			end
			return {:title => title, :description => description, :regexps => regexps}
		end

		def run_regexp(regexp = '', file = '')
			if regexp != ''
				reg = find_regexp(regexp)
			end
		end

		def find_regexp(regexp)
			@@regexp_list.each do |r|
				if r[:title] == regexp
					return r
				end
			end
			return nil
		end

	end
end