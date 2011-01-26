require File.dirname(__FILE__) + "/test_helper.rb"

class SymbolTokenizationTest < Test::Unit::TestCase
  def setup
    @sf = Eden::SourceFile.new( "dummy.rb" )
  end

  def test_simple_symbol_tokenisation
    @sf.stubs(:source).returns(":test :test12 :_rah")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 5, tokens.size
    assert_token tokens[0], :symbol, ":test"
    assert_token tokens[2], :symbol, ":test12"
    assert_token tokens[4], :symbol, ":_rah"
  end

  def test_operator_symbol_tokenization
    @sf.stubs(:source).returns(":% :< :/ :<<")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 7, tokens.size
    assert_token tokens[0], :symbol, ":%"
    assert_token tokens[2], :symbol, ":<"
    assert_token tokens[4], :symbol, ":/"
    assert_token tokens[6], :symbol, ":<<"
  end

  def test_dynamic_symbol_tokenisation
    @sf.stubs(:source).returns(":'dynamic symbol' :\"dynamic symbol\"")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 3, tokens.size
    assert_token tokens[0], :symbol, ":'dynamic symbol'"
    assert_token tokens[2], :symbol, ":\"dynamic symbol\""
  end

  def test_dynamic_symbol_tokenization2
    @sf.stubs(:source).returns("%s{rah}\n%s(rah)\n%s:rah:\n%s<rah<rah>rah>")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 2, tokens.size
    assert_token tokens[0], :symbol, "%s{rah}"
    tokens = @sf.lines[1].tokens
    assert_token tokens[0], :symbol, "%s(rah)"
    tokens = @sf.lines[2].tokens
    assert_token tokens[0], :symbol, "%s:rah:"
    tokens = @sf.lines[3].tokens
    assert_token tokens[0], :symbol,  "%s<rah<rah>rah>"
  end
end
