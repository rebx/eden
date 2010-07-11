module Eden
  # Formatter
  # 
  # A base class providing configuration behaviour for Eden's source code
  # formatters.
  class Formatter
    class << self
      attr_accessor :options
    end

    def self.configure
      yield self
    end

    def self.format( source_file )
      raise "Format function not implmented."
    end

    def self.method_missing(name, *args, &block)
      self.options ||= {}
      self.options[name.to_sym] = *args[0]
    end
  end
end

