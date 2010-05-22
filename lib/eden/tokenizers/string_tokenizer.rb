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
      capture_token( @state )
    end

    def tokenize_backquote_string
      advance # Pass the opening backquote
      advance until( cchar == '`' || @i >= @length )
      advance # Pass the closing backquote
      capture_token( :backquote_string )
    end

    def tokenize_double_quote_string
      advance # Pass the opening backquote
      until( cchar == '"' || @i >= @length )
        if cchar == '\\'
          advance(2) # Pass the escaped character
        else
          advance
        end
      end
      advance # Pass the closing backquote
      capture_token( @state )
    end
  end
end
