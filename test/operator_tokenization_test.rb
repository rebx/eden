require File.dirname(__FILE__) + "/test_helper.rb"

class OperatorTokenizationTest < Test::Unit::TestCase
 def setup
    @sf = Eden::SourceFile.new( "dummy.rb" )
  end

  def test_equals_tokenization
    @sf.stubs(:source).returns("= == => === =~")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 9, tokens.size
    assert_token tokens[0], :equals, "="
    assert_token tokens[2], :equality, "=="
    assert_token tokens[4], :hash_rocket, "=>"
    assert_token tokens[6], :identity_equality, "==="
    assert_token tokens[8], :matches, "=~"
  end

  def test_plus_tokenization
    @sf.stubs(:source).returns("a + 1")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 5, tokens.size
    assert_token tokens[2], :plus, "+"
  end

  def test_plus_equals_tokenization
    @sf.stubs(:source).returns("a += 1")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 5, tokens.size
    assert_token tokens[2], :plus_equals, "+="
  end

  # Not sure if this should actually be parsed as a token?
  def test_plus_at_tokenization
    @sf.stubs(:source).returns("a +@ 1")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 5, tokens.size
    assert_token tokens[2], :plus_at, "+@"
  end

  def test_plus_tokenization_with_ambiguous_plus
    @sf.stubs(:source).returns("a=b+1")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 5, tokens.size
    assert_token tokens[0], :identifier, "a"
    assert_token tokens[3], :plus, "+"
    assert_token tokens[4], :dec_literal, "1"
  end

  def test_plus_tokenization_with_ambiguous_minus
    @sf.stubs(:source).returns("a=b-1")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 5, tokens.size
    assert_token tokens[0], :identifier, "a"
    assert_token tokens[3], :minus, "-"
    assert_token tokens[4], :dec_literal, "1"
  end

  def test_minus_tokenization
    @sf.stubs(:source).returns("a - 1")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 5, tokens.size
    assert_token tokens[2], :minus, "-"
  end

  def test_minus_equals_tokenization
    @sf.stubs(:source).returns("a -= 1")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 5, tokens.size
    assert_token tokens[2], :minus_equals, "-="
  end

  def test_minus_at_tokenization
    @sf.stubs(:source).returns("a -@ 1")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 5, tokens.size
    assert_token tokens[2], :minus_at, "-@"
  end

  def test_multiply_tokenization
    @sf.stubs(:source).returns("* *= ** **=")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 7, tokens.size
    assert_token tokens[0], :multiply, "*"
    assert_token tokens[2], :multiply_equals, "*="
    assert_token tokens[4], :exponent, "**"
    assert_token tokens[6], :exponent_equals, "**="
  end

  def test_divide_tokenization
    @sf.stubs(:source).returns("rah / gah")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 5, tokens.size
    assert_token tokens[2], :divide, "/"
  end
  
  def test_divide_equals_tokenization
    @sf.stubs(:source).returns("rah /= gah")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal tokens.size, 5
    assert_token tokens[2], :divide_equals, "/="
  end

  def test_lt_tokenization
    @sf.stubs(:source).returns("< <= << <<= <=>")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 9, tokens.size
    assert_token tokens[0], :lt, "<"
    assert_token tokens[2], :lte, "<="
    assert_token tokens[4], :left_shift, "<<"
    assert_token tokens[6], :left_shift_equals, "<<="
    assert_token tokens[8], :sort_operator, "<=>"
  end

  def test_gt_tokenization
    @sf.stubs(:source).returns("> >= >> >>=")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 7, tokens.size
    assert_token tokens[0], :gt, ">"
    assert_token tokens[2], :gte, ">="
    assert_token tokens[4], :right_shift, ">>"
    assert_token tokens[6], :right_shift_equals, ">>="
  end

  def test_pipe_tokenization
    @sf.stubs(:source).returns("| |= || ||=")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 7, tokens.size
    assert_token tokens[0], :bitwise_or, "|"
    assert_token tokens[2], :bitwise_or_equals, "|="
    assert_token tokens[4], :logical_or, "||"
    assert_token tokens[6], :logical_or_equals, "||="
  end

  def test_ampersand_tokenization
    @sf.stubs(:source).returns("& &= && &&=")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 7, tokens.size
    assert_token tokens[0], :bitwise_and, "&"
    assert_token tokens[2], :bitwise_and_equals, "&="
    assert_token tokens[4], :logical_and, "&&"
    assert_token tokens[6], :logical_and_equals, "&&="
  end

  def test_caret_tokenization
    @sf.stubs(:source).returns("^ ^=")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 3, tokens.size
    assert_token tokens[0], :caret, "^"
    assert_token tokens[2], :caret_equals, "^="
  end

  def test_modulo_tokenization
    @sf.stubs(:source).returns("% a %=")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 5, tokens.size
    assert_token tokens[0], :modulo, "%"
    assert_token tokens[4], :modulo_equals, "%="
  end

  def test_bang_tokenization
    @sf.stubs(:source).returns("!= !~ !")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 5, tokens.size
    assert_token tokens[0], :not_equals, "!="
    assert_token tokens[2], :not_matches, "!~"
    assert_token tokens[4], :logical_not, "!"
  end
end
