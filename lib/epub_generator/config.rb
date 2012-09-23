require 'yaml'

module EpubGenerator

  class Config

    def initialize(data = {})
      @data = {}
      update!(data)
      if @data.empty?
        self.parse
      end
    end

    def update!(data)
      data.each do |key, value|
        self[key] = value
      end
    end

    def [](key)
      @data[key.to_sym]
    end

    def []=(key, value)
      if value.class == Hash
        @data[key.to_sym] = Config.new(value)
      else
        @data[key.to_sym] = value
      end
    end

    def method_missing(sym, *args)
      if sym.to_s =~ /(.+)=$/
        self[$1] = args.first
      else
        self[sym]
      end
    end

    def parse
      if File.exist?("epub.yml")        
        update!(YAML.load(File.open("epub.yml").read))
      end
    end

    def write
      File.open('epub.yml', 'w+') do |f|
        f.puts YAML.dump(@data)
      end
    end

  end
end
