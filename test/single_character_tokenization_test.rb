$: << File.dirname(__FILE__) + "/../test"
require 'test_helper'

class SingleCharacterTokenizationTest < Test::Unit::TestCase
  def setup
    @sf = Eden::SourceFile.new( "dummy.rb" )
  end

  def test_single_character_tokenisation
    @sf.stubs(:source).returns("<>~!@% ^&*()[]{}|.: ;=? +-")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 26, tokens.size
    assert_token tokens[0], :lt, "<"
    assert_token tokens[1], :gt, ">"
    assert_token tokens[2], :tilde, "~"
    assert_token tokens[3], :logical_not, "!"
    assert_token tokens[4], :at, "@"
    assert_token tokens[5], :modulo, "%"
    assert_token tokens[7], :caret, "^"
    assert_token tokens[8], :bitwise_and, "&"
    assert_token tokens[9], :multiply, "*"
    assert_token tokens[10], :lparen, "("
    assert_token tokens[11], :rparen, ")"
    assert_token tokens[12], :lsquare, "["
    assert_token tokens[13], :rsquare, "]"
    assert_token tokens[14], :lcurly, "{"
    assert_token tokens[15], :rcurly, "}"
    assert_token tokens[16], :bitwise_or, "|"
    assert_token tokens[17], :period, "."
    assert_token tokens[18], :colon, ":"
    assert_token tokens[20], :semicolon, ";"
    assert_token tokens[21], :equals, "="
    assert_token tokens[22], :question_mark, "?"
    assert_token tokens[24], :plus, "+"
    assert_token tokens[25], :minus, "-"
  end

  def test_period_tokenization
    @sf.stubs(:source).returns("... .. .")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 5, tokens.size
    assert_token tokens[0], :range_inc, "..."
    assert_token tokens[2], :range_exc, ".."
    assert_token tokens[4], :period, "."
  end

  def test_colon_tokenization
   @sf.stubs(:source).returns(":test :: : ")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 6, tokens.size
    assert_token tokens[0], :symbol, ":test"
    assert_token tokens[2], :scope_res, "::"
    assert_token tokens[4], :colon,  ":"
  end

end
