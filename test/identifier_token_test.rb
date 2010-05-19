require File.dirname(__FILE__) + "/test_helper.rb"

class IdentifierTokenTest < Test::Unit::TestCase
  def setup
    @sf = Eden::SourceFile.new( "dummy.rb" )
  end

  def test_leading_underscore_identifier_tokenization
    @sf.stubs(:source).returns("    _token")
    @sf.tokenize!
    line = @sf.lines[0]
    assert_equal 2, line.tokens.size
    assert_equal "_token", line.tokens[1].content
    assert_equal :identifier, line.tokens[1].type
  end

  def test_multiple_token_tokenization
    @sf.stubs(:source).returns("token other_token")
    @sf.tokenize!
    line = @sf.lines[0]
    assert_equal 3, line.tokens.size
    assert_equal "token", line.tokens[0].content
    assert_equal :identifier, line.tokens[0].type
    assert_equal "other_token", line.tokens[2].content
    assert_equal :identifier, line.tokens[2].type
  end
end
