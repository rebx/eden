require File.dirname(__FILE__) + "/test_helper.rb"

class RegexTokenizationTest < Test::Unit::TestCase
  def setup
    @sf = Eden::SourceFile.new( "dummy.rb" )
  end

  def test_delimited_regex_tokenization
    @sf.stubs(:source).returns("%r{[a-z]} %r{[a-z]}i")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    puts tokens.inspect
    assert_equal 3, tokens.size
    assert_equal :regex, tokens[0].type
    assert_equal "%r{[a-z]}", tokens[0].content
    assert_equal :regex, tokens[2].type
    assert_equal "%r{[a-z]}i", tokens[2].content
  end
end
