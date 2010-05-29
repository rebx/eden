require File.dirname(__FILE__) + "/test_helper.rb"

class ArrayLiteralTokenizationTest < Test::Unit::TestCase
  def setup
    @sf = Eden::SourceFile.new( "dummy.rb" )
  end

  def test_simple_symbol_tokenisation
    @sf.stubs(:source).returns("%w{rah rah rah} %w<rah <rah> rah>")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 3, tokens.size
    assert_equal :array_literal, tokens[0].type
    assert_equal "%w{rah rah rah}", tokens[0].content
    assert_equal :array_literal, tokens[2].type
    assert_equal "%w<rah <rah> rah>", tokens[2].content
  end
end
