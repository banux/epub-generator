require 'thor'
require 'epub_generator/config'
require 'epub_generator/clean_regexp'

module EpubGenerator
  class CLI < Thor
    include Thor::Actions

    desc "new DIRECTORY", "Create a new working"
    def new(directory)
      Dir.mkdir(directory)
      config = EpubGenerator::Config.new(directory)
    end

    desc "generate", "generate epub from working directory"
    def generate()
      config = EpubGenerator::Config.new
    end

    desc "regexp REGEXP", "execute regexp on html"
    method_option :value, :default => ""
    def regexp(reg_class)
      config = EpubGenerator::Config.new
      reg  = CleanRegexp.new
      if reg_class == ""
        reg.list_regexp
      else
        config.get_html_files.each do |f|
          reg.run_regexp(reg_class, f)
        end
      end
    end

  end
end
