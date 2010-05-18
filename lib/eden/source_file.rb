require 'syntax'

module Eden
  class SourceFile
    attr_accessor :source, :lines

    def initialize( file_name )
      @file_name = file_name
      @lines = []
    end

    def load!
      @source = File.read( @file_name, "r" )
    end

    def tokenize!
      tokenizer = Tokenizer.new( self )
      tokenizer.tokenize!
    end
  end
end
