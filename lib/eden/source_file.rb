require 'ftools'

module Eden
  class SourceFile
    attr_accessor :source, :lines

    def initialize( file_name )
      @file_name = file_name
      @lines = []
    end

    def changed?
      @lines.each { |l| return true if l.changed? }
      return false
    end

    def load!
      file = File.open( @file_name, "r" )
      @source = file.read
    end

    def tokenize!
      tokenizer = Tokenizer.new( self )
      tokenizer.tokenize!
    end

    def each_line
      @lines.each { |l| yield l }
    end

    def rewrite!( make_backup = false )
      if make_backup
        File.move(@file_name, @file_name + "~") if changed?
      end

      File.open(@file_name, 'w') do |f|
        each_line do |l|
          f.write l.joined_tokens
        end
      end
    end
  end
end
