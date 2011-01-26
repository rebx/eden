require File.dirname(__FILE__) + "/test_helper.rb"

class NumberTokenizationTest < Test::Unit::TestCase
  def setup
    @sf = Eden::SourceFile.new( "dummy.rb" )
  end

  def test_binary_tokenization
    @sf.stubs(:source).returns("b12345 0b01010 0b11056")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 6, tokens.size
    assert_token tokens[0], :identifier, "b12345"
    assert_token tokens[2], :bin_literal, "0b01010"
    assert_token tokens[4], :bin_literal, "0b110"
  end

  def test_hexadecimal_tokenisation
    @sf.stubs(:source).returns("0x0123 0x0F 0xDEADBEEF 0x0FRR")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 8, tokens.size
    assert_token tokens[0], :hex_literal, "0x0123"
    assert_token tokens[2], :hex_literal, "0x0F"
    assert_token tokens[4], :hex_literal, "0xDEADBEEF"
    assert_token tokens[6], :hex_literal, "0x0F"
  end

  def test_signed_tokenization
    @sf.stubs(:source).returns("-10, +4")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 4, tokens.size
    assert_token tokens[0], :dec_literal, "-10"
    assert_token tokens[3], :dec_literal, "+4"
  end

  def test_decimal_tokenisation
    @sf.stubs(:source).returns("123 9123 0d1987")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 5, tokens.size
    assert_token tokens[0], :dec_literal, "123"
    assert_token tokens[2], :dec_literal, "9123"
    assert_token tokens[4], :dec_literal, "0d1987"
  end

  def test_float_tokenisation
    # TODO: Add test that 123.method doens't tokenize as float
    @sf.stubs(:source).returns("123.0")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 1, tokens.size
    assert_token tokens[0], :float_literal, "123.0"
  end

  def test_exponent_tokenisation
    @sf.stubs(:source).returns("123e24 1.032e-12 1.32e+12")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 5, tokens.size
    assert_token tokens[0], :exp_literal, "123e24"
    assert_token tokens[2], :exp_literal, "1.032e-12"
    assert_token tokens[4], :exp_literal, "1.32e+12"
  end
end
