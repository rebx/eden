module Eden
  module BasicTokenizer
    def tokenize_single_character
      @thunk_end += 1
      token = Token.new(@state, thunk)
      @i += 1
      reset_thunk!
      default_state_transitions!
      return token
    end

    def tokenize_identifier
      advance until( /[A-Za-z0-9_]/.match( cchar ).nil? )
      capture_token( @state )
    end

    def tokenize_whitespace
      advance until( cchar != ' ' && cchar != '\t' )
      capture_token( :whitespace )
    end

    def tokenize_instancevar
      advance # Pass the @ symbol
      advance until( /[a-z0-9_]/.match( cchar ).nil? )
      capture_token( :instancevar )
    end

    def tokenize_classvar
      advance(2) # Pass the @@ symbol
      advance until( /[a-z0-9_]/.match( cchar ).nil? )
      capture_token( :classvar )
    end

    def tokenize_symbol
      advance # Pass the :
      case cchar
      when '"'  then return tokenize_double_quote_string
      when '\'' then return tokenize_single_quote_string
      end
      advance until( cchar == ' ' || cchar.nil? )
      capture_token( :symbol )
    end
  end
end
