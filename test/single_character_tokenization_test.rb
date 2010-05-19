require File.dirname(__FILE__) + "/test_helper.rb"

class NumberTokenizationTest < Test::Unit::TestCase
  def setup
    @sf = Eden::SourceFile.new( "dummy.rb" )
  end

  def test_single_character_tokenisation
    @sf.stubs(:source).returns("<>!~@%^&*()[]{}|.:;=?")
    @sf.tokenize!
    line = @sf.lines[0]
    assert_equal 21, line.tokens.size
    assert_equal "<", line.tokens[0].content
    assert_equal :lt, line.tokens[0].type
    assert_equal ">", line.tokens[1].content
    assert_equal :gt, line.tokens[1].type
    assert_equal "!", line.tokens[2].content
    assert_equal :bang, line.tokens[2].type
    assert_equal "~", line.tokens[3].content
    assert_equal :tilde, line.tokens[3].type
    assert_equal "@", line.tokens[4].content
    assert_equal :at, line.tokens[4].type
    assert_equal "%", line.tokens[5].content
    assert_equal :modulo, line.tokens[5].type
    assert_equal "^", line.tokens[6].content
    assert_equal :caret, line.tokens[6].type
    assert_equal "&", line.tokens[7].content
    assert_equal :ampersand, line.tokens[7].type
    assert_equal "*", line.tokens[8].content
    assert_equal :multiply, line.tokens[8].type
    assert_equal "(", line.tokens[9].content
    assert_equal :lparen, line.tokens[9].type
    assert_equal ")", line.tokens[10].content
    assert_equal :rparen, line.tokens[10].type
    assert_equal "[", line.tokens[11].content
    assert_equal :lsquare, line.tokens[11].type
    assert_equal "]", line.tokens[12].content
    assert_equal :rsquare, line.tokens[12].type
    assert_equal "{", line.tokens[13].content
    assert_equal :lcurly, line.tokens[13].type
    assert_equal "}", line.tokens[14].content
    assert_equal :rcurly, line.tokens[14].type
    assert_equal "|", line.tokens[15].content
    assert_equal :pipe, line.tokens[15].type
    assert_equal ".", line.tokens[16].content
    assert_equal :period, line.tokens[16].type
    assert_equal ":", line.tokens[17].content
    assert_equal :colon, line.tokens[17].type
    assert_equal ";", line.tokens[18].content
    assert_equal :semicolon, line.tokens[18].type
    assert_equal "=", line.tokens[19].content
    assert_equal :equals, line.tokens[19].type
    assert_equal "?", line.tokens[20].content
    assert_equal :question_mark, line.tokens[20].type    
  end

end
