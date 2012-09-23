
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
			title = lines[0].chomp
			description = lines[1].chomp
			regexps = []
			i = 2
			while i < lines.size
				search_str = lines[i].chomp
				i = i + 1
				replace_str = lines[i].chomp
				i = i + 1
				regexps.push({:search_str => Regexp.new(search_str), :replace_str => replace_str})
			end
			return {:title => title, :description => description, :regexps => regexps}
		end

		def run_regexp(regexp = '', file = '')
			if regexp != ''
				reg = find_regexp(regexp)
				puts "running " + reg[:title] + ' on ' + file
				buff = File.open(file).read
				reg[:regexps].each do |r|
					buff.gsub!(r[:search_str], r[:replace_str])
				end
				File.open(file, "w") { |file| file.puts buff }
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