require File.dirname(__FILE__) + "/test_helper.rb"

class RegexTokenizationTest < Test::Unit::TestCase
  def setup
    @sf = Eden::SourceFile.new( "dummy.rb" )
  end

  def test_delimited_regex_tokenization
    @sf.stubs(:source).returns("%r{[a-z]}")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 1, tokens.size
    assert_token tokens[0], :regex, "%r{[a-z]}"
  end

  def test_delimited_regex_tokenization2
    @sf.stubs(:source).returns("%r{[a-z]}i")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 1, tokens.size
    assert_token tokens[0], :regex, "%r{[a-z]}i"
  end

  def test_regex_tokenization_at_line_start
    @sf.stubs(:source).returns("/[asdf]/")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 1, tokens.size
    assert_token tokens[0], :regex, "/[asdf]/"
  end

  def test_ambiguous_regex_tokenization
    @sf.stubs(:source).returns("a = b / c\nd = f / g")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens + @sf.lines[1].tokens
    tokens.each {|t| assert t.type != :regex }
  end

  def test_regex_tokenization_with_escape_characters
    @sf.stubs(:source).returns("/test\\/test/")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 1, tokens.size
    assert_token tokens[0], :regex, "/test\\/test/"
  end

  def test_regex_tokenization_with_modifiers
    @sf.stubs(:source).returns("/test/i")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 1, tokens.size
    assert_token tokens[0], :regex, "/test/i"
  end

  def test_regex_tokenization_with_funky_regexes
    @sf.stubs(:source).returns(%q{%r!\[ *(?:(@)([\w\(\)-]+)|([\w\(\)-]+\(\))) *([~\!\|\*$\^=]*) *'?"?([^'"]*)'?"? *\]!i})
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 1, tokens.size
    assert_token tokens[0], :regex, %q{%r!\[ *(?:(@)([\w\(\)-]+)|([\w\(\)-]+\(\))) *([~\!\|\*$\^=]*) *'?"?([^'"]*)'?"? *\]!i}
  end
end
