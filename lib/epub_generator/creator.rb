require 'eeepub'
require 'uuid'

module EpubGenerator
	class Creator

		def initialize(config, filename)
			files_content = config.html + config.css + config.font
			nav_content = []
			uuid = UUID.new.generate
			config.html.each do |filename|
				nav_content << {:label => filename, :content => filename}
			end
			epub = EeePub::Maker.new do
				title       config.title
				creator     config.author
				publisher   config.publisher
				date        Date.today
				identifier  uuid, :scheme => 'UUID'

				files files_content
				nav nav_content
			end
			epub.save(filename)
		end

	end
end