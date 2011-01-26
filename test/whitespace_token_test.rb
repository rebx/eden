require File.dirname(__FILE__) + "/test_helper.rb"

class WhitespaceTokenTest < Test::Unit::TestCase
  def setup
    @sf = Eden::SourceFile.new( "dummy.rb" )
  end

  def test_leading_whitespace_tokenization
    @sf.stubs(:source).returns("    token")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 2, tokens.size
    assert_token tokens[0], :whitespace, "    "
  end

  def test_leading_whitespace_tab_tokenization
    @sf.stubs(:source).returns("\t\ttoken")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 2, tokens.size
    assert_token tokens[0], :whitespace, "\t\t"
  end

  def test_leading_whitespace_multiple_space_tokenization
    @sf.stubs(:source).returns("\t token")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 2, tokens.size
    assert_token tokens[0], :whitespace, "\t "
  end

  def test_trailing_whitespace_tokenization
    @sf.stubs(:source).returns("token    ")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 2, tokens.size
    assert_token tokens[1], :whitespace, "    "
  end

  def test_interstitial_whitespace_tokenization
    @sf.stubs(:source).returns("token token")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 3, tokens.size
    assert_token tokens[1], :whitespace, " "
  end

  def test_comment_tokenization
    @sf.stubs(:source).returns("token # Comment Rah Rah Rah\n")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 4, tokens.size
    assert_token tokens[2], :comment, "# Comment Rah Rah Rah"
    assert_token tokens[3], :newline,  "\n"
  end
end
