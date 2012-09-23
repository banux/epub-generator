require 'thor'
require 'epub_generator/config'
require 'epub_generator/clean_regexp'
require 'epub_generator/split'
require 'epub_generator/creator'

module EpubGenerator
  class CLI < Thor
    include Thor::Actions

    def self.source_root
      File.dirname(__FILE__) + '/../../'
    end

    desc "new DIRECTORY", "Create a new working"
    def new(directory)
      Dir.mkdir(directory)
      template('templates/epub.yml.tt', directory + "/epub.yml")
    end

    desc "generate FILENAME", "generate epub from working directory"
    def generate(filename)
      config = EpubGenerator::Config.new
      epub = EpubGenerator::Creator.new(config, filename)
    end

    desc "split_html", "split html file"
    def split_html()
      config = EpubGenerator::Config.new
      if config.html.size > 1
        puts "html is already split"
      else
        split_epub = EpubGenerator::Split.new(config)
        config.html = split_epub.get_html_list
        config.html.flatten!
        config.write
      end
    end

    desc "regexp REGEXP", "execute regexp on html"
    def regexp(reg_class = "list")
      config = EpubGenerator::Config.new
      reg  = CleanRegexp.new
      if reg_class == "list"
        reg.list_regexp
      else
        config.html.each do |f|
          reg.run_regexp(reg_class, f)
        end
      end
    end

  end
end
