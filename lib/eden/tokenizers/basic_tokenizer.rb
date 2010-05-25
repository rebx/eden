require 'rubygems'
require 'ruby-debug'

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

    def tokenize_equals_operators
      advance
      case cchar
      when '>'
        advance and return capture_token(:hash_rocket)
      when "~"
        advance and return capture_token(:matches)
      when '='
        advance
        if cchar == '='
          advance and return capture_token(:identity_equality)
        else
          return capture_token(:equality)
        end
      else
        return capture_token(:equals)
      end
    end

    def tokenize_bang_operators
      advance
      case cchar
      when '='
        advance and capture_token(:not_equals)
      when '~'
        advance and capture_token(:not_matches)
      else
        capture_token(:logical_not)
      end
    end

    def tokenize_plus_operators
      advance
      case cchar
      when '='
        advance
        return capture_token(:plus_equals)
      when '@'
        advance
        return capture_token(:plus_at)
      else
        return capture_token(:plus)
      end
    end

    def tokenize_minus_operators
      advance
      case cchar
      when '='
        advance
        return capture_token(:minus_equals)
      when '@'
        advance
        return capture_token(:minus_at)
      else
        return capture_token(:minus)
      end
    end

    def tokenize_multiply_operators
      advance
      case cchar
      when '*'
        advance
        if cchar == '='
          advance
          return capture_token(:exponent_equals)
        else
          return capture_token(:exponent)
        end
      when '='
        advance
        return capture_token(:multiply_equals)
      else
        return capture_token(:multiply)
      end
    end

    def tokenize_divide_operators
      advance
      if cchar == '='
        advance
        return capture_token(:divide_equals)
      else
        return capture_token(:divide)
      end
    end

    def tokenize_lt_operators
      advance
      case cchar
      when '<'
        advance
        if cchar == '='
          advance
          return capture_token(:left_shift_equals)
        else
          return capture_token(:left_shift)
        end
      when '='
        advance
        if cchar == '>'
          advance
          return capture_token(:sort_operator)
        else
          return capture_token(:lte)
        end
      else
        return capture_token(:lt)
      end
    end

    def tokenize_gt_operators
      advance
      case cchar
      when '>'
        advance
        if cchar == '='
          advance and capture_token(:right_shift_equals)
        else
          capture_token(:right_shift)
        end
      when '='
        advance and capture_token(:gte)
      else
        capture_token(:gt)
      end
    end

    def tokenize_pipe_operators
      advance
      case cchar
      when '|'
        advance
        if cchar == '='
          advance and capture_token(:logical_or_equals)
        else
          capture_token(:logical_or)
        end
      when '='
        advance and capture_token(:bitwise_or_equals)
      else
        capture_token(:bitwise_or)
      end
    end

    def tokenize_ampersand_operators
      advance
      case cchar
      when '&'
        advance
        if cchar == '='
          advance and capture_token(:logical_and_equals)
        else
          capture_token(:logical_and)
        end
      when '='
        advance and capture_token(:bitwise_and_equals)
      else
        capture_token(:bitwise_and)
      end
    end

    def tokenize_caret_operators
      advance
      if cchar == "="
        advance and capture_token(:caret_equals)
      else
        capture_token(:caret)
      end
    end

    def tokenize_modulo_operators
      advance
      if cchar == "="
        advance and capture_token(:modulo_equals)
      else
        capture_token(:modulo)
      end
    end

    def tokenize_rcurly
      @thunk_end += 1
      old_state = @interpolating.delete_at(-1)
      tokens = []
      if old_state
        tokens << Token.new(@state, thunk)
        @i += 1
        reset_thunk!
        @state = old_state
        tokens << tokenize_double_quote_string
      else
        tokens << Token.new(@state, thunk)
        @i += 1
        reset_thunk!
      end
      default_state_transitions!
      return tokens
    end

    def tokenize_identifier
      advance until( /[A-Za-z0-9_]/.match( cchar ).nil? )
      translate_keyword_tokens(capture_token( @state ))
    end

    def tokenize_whitespace
      advance until( cchar != ' ' && cchar != '\t' )
      capture_token( :whitespace )
    end

    def tokenize_comment
      advance until( cchar == "\n" || cchar.nil?)
      capture_token( :comment )
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

    # Takes an identifier token, and tranforms its type to
    # match Ruby keywords where the identifier is actually a keyword.
    # Reserved words are defined in S.8.5.1 of the Ruby spec.
    def translate_keyword_tokens( token )
      keywords = ["__LINE__", "__ENCODING__", "__FILE__", "BEGIN",   
                  "END", "alias", "and", "begin", "break", "case",
                  "class", "def", "defined?", "do", "else", "elsif",
                  "end", "ensure", "false", "for", "if", "in",
                  "module", "next", "nil", "not", "or", "redo",
                  "rescue", "retry", "return", "self", "super",
                  "then", "true", "undef", "unless", "until", 
                  "when", "while", "yield"]
      if keywords.include?( token.content )
        token.type = token.content.downcase.to_sym
      end
      
      # A couple of exceptions
      token.type = :begin_global if token.content == "BEGIN"
      token.type = :end_global if token.content == "END"

      return token
    end
  end
end
