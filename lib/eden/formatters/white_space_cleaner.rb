require 'ruby-debug'

class WhiteSpaceCleaner < Eden::Formatter
  def self.format( source_file )
    return unless options[:remove_trailing_whitespace]

    source_file.each_line do |l|
      i = l.tokens.size - 1
      while( i >= 0 )
        break unless (l.tokens[i].type == :whitespace || l.tokens[i].type == :newline)
        l.tokens.delete_at(i) if l.tokens[i].type == :whitespace          
        i -= 1
      end
    end
  end
end
