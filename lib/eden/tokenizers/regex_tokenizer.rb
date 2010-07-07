module Eden
  module RegexTokenizer
    def tokenize_potential_regex
      prev_token = @current_line.last_non_whitespace_token
      
      return tokenize_regex if prev_token.nil?
      return tokenize_regex if prev_token.keyword?
      return tokenize_regex if prev_token.operator?
      return tokenize_divide if prev_token.literal?
      
      case prev_token.type
      when :lparen, :lsquare, :lcurly, :hash_rocket
        return tokenize_regex
      when :rparen, :rsquare, :rcurly
        return tokenize_divide
      when :question_mark, :equals, :semicolon
        return tokenize_regex
      when :instancevar, :classvar, :globalvar
        return tokenize_divide
      when :identifier
        if can_tokenize_regex?
          return tokenize_regex
        else
          return tokenize_divide
        end
      else
        raise "You forgot #{prev_token.type}!"
      end



    end

    def tokenize_divide
    end

    def tokenize_regex
    end

    def can_tokenize_regex
      cp = @i

      until @sf.source[cp] == '/'  ||
            cp > length 
      end
        
      end
    end
  end
end
