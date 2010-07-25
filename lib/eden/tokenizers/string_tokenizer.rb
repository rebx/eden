module Eden
  module StringTokenizer
    def tokenize_single_quote_string
      advance # Pass the opening quote
      until( cchar == '\'' || @i >= @length)
        if cchar == '\\'
          advance(2) # Pass the escaped character
        else
          advance
        end
      end
      advance # Pass the closing quote
      @expr_state = :end
      capture_token( @state )
    end

    def tokenize_backquote_string
      advance
      advance until cchar == '`' || @i >= @length
      advance
      @expr_state = :end
      capture_token( :backquote_string )
    end

    def tokenize_double_quote_string( in_string_already = false )
      saved_state = @state
      tokens = []
      advance unless in_string_already # Pass the opening backquote
      until( cchar == '"' || @i >= @length )
        if cchar == '\\'
          advance(2) # Pass the escaped character
        elsif cchar == '#'
          advance # include the # character in the string
          case cchar
          when '{'
            @interpolating << @state
            tokens << Token.new( @state, thunk )
            reset_thunk!
            @state = :lcurly
            tokens << tokenize_single_character
            return tokens
          when '@'
            tokens << capture_token( @state )
            if peek_ahead_for('@')
              tokens << tokenize_classvar
            else
              tokens << tokenize_instancevar
            end
            @state = saved_state
          when '$'
            tokens << capture_token( @state )
            tokens << tokenize_globalvar
            @state = saved_state
          end
        else
          advance
        end
      end
      advance # Pass the closing double-quote
      @expr_state = :end
      tokens << capture_token( @state )
      return tokens
    end
  
    # Called from tokenize_lt_operators when it identifies that 
    # << is a heredoc delimiter. Expects that '<<' will already
    # be included in the current thunk.
    def tokenize_heredoc_delimiter
      offset = 2
      if cchar == '-'
        advance
        offset = 3
      end

      if cchar =~ /[A-Za-z_]/
        advance
        advance until /[A-Za-z0-9_]/.match( cchar ).nil?
      elsif /['"`]/.match(cchar)
        advance_through_quoted_delimiter(cchar)
      else
        return nil
      end
      @heredoc_delimiter = thunk[offset..-1]
      capture_token( :heredoc_delimiter )
    end

    def advance_through_quoted_delimiter( delimiter )
      advance
      advance until cchar == delimiter
      advance
    end

    def tokenize_heredoc_body
      if @heredoc_delimiter
        advance until @sf.source[@i, @heredoc_delimiter.length] == @heredoc_delimiter || @i >= @length
      end
      @heredoc_delimiter.length.times { advance }
      @heredoc_delimiter = nil
      capture_token( :heredoc_body )
    end
  end
end
