module Eden
  class Token
    attr_accessor :type, :content

    def initialize( type, content )
      @type = type
      @content = content
    end

    def inspect
      if @content.nil? || @content == "\n"
        @type.to_s
      else
        @type.to_s + "- \"" + @content + "\""
      end
    end
  end
end
