module Eden
  module DelimitedLiteralTokenizer
    def tokenize_delimited_literal
      match_delimiter = false
      end_delimiter, start_delimiter = nil, nil
      delimiter_depth = 0

      advance # Pass the %
      @state = infer_delimited_literal_type

      advance # Pass the literal-type identifier

      if( /[\{\(\[\<]/.match( cchar ) )
        matched_delimiter = true
        start_delimiter = cchar
        end_delimiter = find_matching_delimiter( cchar )
      elsif( /[^A-Za-z0-9_ ]/.match(cchar) )
        matched_delimiter = false
        end_delimiter = cchar
      else
        raise "Invalid delimiter character"
      end

      advance # past the delimiter
      
      until((cchar == end_delimiter && delimiter_depth == 0) || @i >= @length )
        if matched_delimiter
          delimiter_depth += 1 if cchar == start_delimiter
          delimiter_depth -= 1 if cchar == end_delimiter
        end
        advance
      end
      
      if( @i < @length )
        advance # Capture the closing delimiter
      end

      # Regex option - See Section 8.5.5.4
      if @state == :regex
        advance if (cchar == 'i' or cchar == 'm')
      end

      capture_token( @state )
    end

    def infer_delimited_literal_type
      case cchar
        when 's' then :symbol
        when 'w', 'W' then :array_literal
        when 'q', 'Q' then :single_q_string
        when 'r' then :regex
        when 'x' then :backquote_string
      end
    end

    def find_matching_delimiter( start_delimiter )
      case start_delimiter
      when '{' then '}'
      when '(' then ')'
      when '[' then ']'
      when '<' then '>'
      else
        raise "Non matching delimiter"
      end
    end
  end
end
