require File.dirname(__FILE__) + "/test_helper.rb"

class NumberTokenizationTest < Test::Unit::TestCase
  def setup
    @sf = Eden::SourceFile.new( "dummy.rb" )
  end

  def test_simple_symbol_tokenisation
    @sf.stubs(:source).returns(":test :< :_rah")
    @sf.tokenize!
    line = @sf.lines[0]
    assert_equal 5, line.tokens.size
    assert_equal ":test", line.tokens[0].content
    assert_equal :symbol, line.tokens[0].type
    assert_equal ":<", line.tokens[2].content
    assert_equal :symbol, line.tokens[2].type
    assert_equal ":_rah", line.tokens[4].content
    assert_equal :symbol, line.tokens[4].type
  end

end
