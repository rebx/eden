module Eden
  class SourceFile
    attr_accessor :source, :lines

    def initialize( file_name )
      @file_name = file_name
      @lines = []
    end

    def load!
      file = File.open( @file_name, "r" )
      @source = file.read
    end

    def tokenize!
      tokenizer = Tokenizer.new( self )
      tokenizer.tokenize!
    end
  end
end
