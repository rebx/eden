require File.dirname(__FILE__) + "/test_helper.rb"

class WhitespaceTokenTest < Test::Unit::TestCase
  def setup
    @sf = Eden::SourceFile.new( "dummy.rb" )
  end

  def test_leading_whitespace_tokenization
    @sf.stubs(:source).returns("    token")
    @sf.tokenize!
    line = @sf.lines[0]
    assert_equal 2, line.tokens.size
    assert_equal "    ", line.tokens[0].content
    assert_equal :whitespace, line.tokens[0].type
  end

  def test_trailing_whitespace_tokenization
    @sf.stubs(:source).returns("token    ")
    @sf.tokenize!
    line = @sf.lines[0]
    assert_equal 2, line.tokens.size
    assert_equal "    ", line.tokens[1].content
    assert_equal :whitespace, line.tokens[1].type
  end

  def test_interstitial_whitespace_tokenization
    @sf.stubs(:source).returns("token token")
    @sf.tokenize!
    line = @sf.lines[0]
    assert_equal 3, line.tokens.size
    assert_equal " ", line.tokens[1].content
    assert_equal :whitespace, line.tokens[1].type
  end
end
