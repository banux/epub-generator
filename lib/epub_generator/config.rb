require 'yaml'
require 'psych'

module EpubGenerator

  class Config

    DEFAULT_CONFIG = 'epub.yaml'

    attr_reader :html, :css, :font, :title, :author, :metadata

    def initialize(new_directory = '')
      if(new_directory != '')        
        @@html ||= ['ebook.xhtml']
        @@css ||= ['ebook.css']
        @@font ||= []
        @@title ||= ''
        @@author ||= ''
        @@metadata ||= []
        create(new_directory)
      else
        parse(DEFAULT_CONFIG)
      end
    end

    def create(directory)
      f = File.open(directory + '/' + DEFAULT_CONFIG.to_s, 'w+')
      conf = {
        :html => @@html, :css => @@css, :font => @@font,
        :metadata => {:author => @@author, :title => @@title}
     }
     f.puts Psych.dump conf
     f.close
    end

    def parse(file)
      conf = Psych.load(File.open(DEFAULT_CONFIG).read)
      puts conf.inspect
    end

  end

end
