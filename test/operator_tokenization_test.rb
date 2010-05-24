require File.dirname(__FILE__) + "/test_helper.rb"

class OperatorTokenizationTest < Test::Unit::TestCase
  def setup
    @sf = Eden::SourceFile.new( "dummy.rb" )
  end

  def test_equals_tokenization
    @sf.stubs(:source).returns("= == =>")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 5, tokens.size
    assert_equal :equals, tokens[0].type
    assert_equal "=", tokens[0].content
    assert_equal :equality, tokens[2].type
    assert_equal "==", tokens[2].content
    assert_equal :hash_rocket, tokens[4].type
    assert_equal "=>", tokens[4].content
  end

  def test_plus_tokenization
    @sf.stubs(:source).returns("+ += +@")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 5, tokens.size
    assert_equal :plus, tokens[0].type
    assert_equal "+", tokens[0].content
    assert_equal :plus_equals, tokens[2].type
    assert_equal "+=", tokens[2].content
    assert_equal :plus_at, tokens[4].type
    assert_equal "+@", tokens[4].content
  end

  def test_minus_tokenization
    @sf.stubs(:source).returns("- -= -@")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 5, tokens.size
    assert_equal :minus, tokens[0].type
    assert_equal "-", tokens[0].content
    assert_equal :minus_equals, tokens[2].type
    assert_equal "-=", tokens[2].content
    assert_equal :minus_at, tokens[4].type
    assert_equal "-@", tokens[4].content
  end

  def test_multiply_tokenization
    @sf.stubs(:source).returns("* *= ** **=")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 7, tokens.size
    assert_equal :multiply, tokens[0].type
    assert_equal "*", tokens[0].content
    assert_equal :multiply_equals, tokens[2].type
    assert_equal "*=", tokens[2].content
    assert_equal :exponent, tokens[4].type
    assert_equal "**", tokens[4].content
    assert_equal :exponent_equals, tokens[6].type
    assert_equal "**=", tokens[6].content
  end

  def test_divide_tokenization
    @sf.stubs(:source).returns("/ /=")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 3, tokens.size
    assert_equal :divide, tokens[0].type
    assert_equal "/", tokens[0].content
    assert_equal :divide_equals, tokens[2].type
    assert_equal "/=", tokens[2].content
  end
end
