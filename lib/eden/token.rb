module Eden
  class Token
    attr_accessor :type, :content

    def initialize( type, content )
      @type = type
      @content = content
    end
  end
end
