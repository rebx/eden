module Eden
  class Line
    attr_accessor :line_no, :tokens

    def initialize( line_no )
      @line_no = line_no
      @tokens = []
      @warnings = []
    end

    def flatten!
      @tokens.flatten!
      self
    end

    def last_token_is_space?
      @tokens[-1].type == :whitespace
    end
  end
end
