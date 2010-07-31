require File.dirname(__FILE__) + "/test_helper"

class BasicTokenizationTest < Test::Unit::TestCase
  def setup
    @sf = Eden::SourceFile.new("dummy.rb")
  end

  def test_should_tokenize_linebreak_escape
    @sf.stubs(:source).returns("puts \\\n  'rah'")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 4, tokens.size
    assert_equal :backslash, tokens[2].type
    assert_equal :newline, tokens[3].type
  end
end
