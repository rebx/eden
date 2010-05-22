require File.dirname(__FILE__) + "/test_helper.rb"

class NumberTokenizationTest < Test::Unit::TestCase
  def setup
    @sf = Eden::SourceFile.new( "dummy.rb" )
  end

  def test_single_quote_string_tokenisation
    @sf.stubs(:source).returns("'test' 'te\\'st' 'te\\\\st' 'te\"st'")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 7, tokens.size
    assert_equal :single_q_string, tokens[0].type
    assert_equal "'test'", tokens[0].content
    assert_equal :single_q_string, tokens[2].type
    assert_equal "'te\\'st'", tokens[2].content
    assert_equal :single_q_string, tokens[4].type
    assert_equal "'te\\\\st'", tokens[4].content
    assert_equal :single_q_string, tokens[6].type
    assert_equal "'te\"st'", tokens[6].content
  end

  def test_backquote_string_tokenisation
    @sf.stubs(:source).returns("`exec` `exec \#\{\"cmd\"\}` `end")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 5, tokens.size
    assert_equal :backquote_string, tokens[0].type
    assert_equal "`exec`", tokens[0].content
    assert_equal :backquote_string, tokens[2].type
    assert_equal "`exec \#\{\"cmd\"\}`", tokens[2].content
    assert_equal :backquote_string, tokens[4].type
    assert_equal "`end", tokens[4].content
  end

  def test_double_quote_string_tokenisation
    @sf.stubs(:source).returns('"test" "test\#\{inter\}test" "end')
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 5, tokens.size
    assert_equal :double_q_string, tokens[0].type
    assert_equal '"test"', tokens[0].content
    assert_equal :double_q_string, tokens[2].type
    assert_equal '"test\#\{inter\}test"', tokens[2].content
    assert_equal :double_q_string, tokens[4].type
    assert_equal '"end', tokens[4].content
  end

  def test_double_quote_string_escaping
    @sf.stubs(:source).returns('"te\\"st" "test\\\\test"')
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 3, tokens.size
    assert_equal :double_q_string, tokens[0].type
    assert_equal '"te\\"st"', tokens[0].content
    assert_equal :double_q_string, tokens[2].type
    assert_equal '"test\\\\test"', tokens[2].content
  end

end
