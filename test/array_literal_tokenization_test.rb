require File.dirname(__FILE__) + "/test_helper.rb"

class ArrayLiteralTokenizationTest < Test::Unit::TestCase
  def setup
    @sf = Eden::SourceFile.new( "dummy.rb" )
  end

  def test_array_literal_tokenization
    @sf.stubs(:source).returns("%w{rah rah rah}\n%w<rah <rah> rah>")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 2, tokens.size
    assert_token tokens[0], :array_literal, "%w{rah rah rah}"
    tokens = @sf.lines[1].tokens
    assert_token tokens[0], :array_literal, "%w<rah <rah> rah>"
  end

  def test_should_not_expand_delimited_array_literal
    @sf.stubs(:source).returns("%w{rah \#{@inst} rah}\n")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 2, tokens.size
    assert_token tokens[0], :array_literal, "%w{rah \#{@inst} rah}"
    assert_token tokens[1], :newline, "\n"
  end

  def test_should_tokenize_expanded_array_literal
    @sf.stubs(:source).returns("%W{rah \#{@inst} rah}\n")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 6, tokens.size
    assert_token tokens[0], :array_literal,"%W{rah \#"
    assert_token tokens[1], :lcurly
    assert_token tokens[2], :instancevar, "@inst"
    assert_token tokens[3], :rcurly
    assert_token tokens[4], :array_literal, " rah}"
  end
end
