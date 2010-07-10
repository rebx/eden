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
      advance # Pass the opening backquote
      advance until( cchar == '`' || @i >= @length )
      advance # Pass the closing backquote
      @expr_state = :end
      capture_token( :backquote_string )
    end

    def tokenize_double_quote_string
      tokens = []
      advance # Pass the opening backquote
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
              tokens << tokenize_class_var
            else
              tokens << tokenize_instance_var
            end
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
  end
end
