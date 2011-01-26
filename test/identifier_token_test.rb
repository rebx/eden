require File.dirname(__FILE__) + "/test_helper.rb"

class IdentifierTokenTest < Test::Unit::TestCase
  def setup
    @sf = Eden::SourceFile.new( "dummy.rb" )
  end

  def test_leading_underscore_identifier_tokenization
    @sf.stubs(:source).returns("    _token")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 2, tokens.size
    assert_token tokens[1], :identifier, "_token"
  end

  def test_multiple_token_tokenization
    @sf.stubs(:source).returns("token other_token")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 3, tokens.size
    assert_token tokens[0], :identifier, "token"
    assert_token tokens[2], :identifier, "other_token"
  end

  def test_keyword_tokenization_1
    @sf.stubs(:source).returns("__FILE__ __ENCODING__ __LINE__ BEGIN END")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 9, tokens.size
    assert_token tokens[0], :__file__, "__FILE__"
    assert_token tokens[2], :__encoding__, "__ENCODING__"
    assert_token tokens[4], :__line__, "__LINE__"
    assert_token tokens[6], :begin_global, "BEGIN"
    assert_token tokens[8], :end_global, "END"
  end

  def test_keyword_tokenization_2
    @sf.stubs(:source).returns("alias and begin break case class def do end")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 17, tokens.size
    assert_token tokens[0], :alias, "alias"
    assert_token tokens[2], :and, "and"
    assert_token tokens[4], :begin, "begin"
    assert_token tokens[6], :break, "break"
    assert_token tokens[8], :case, "case"
    assert_token tokens[10], :class, "class"
    assert_token tokens[12], :def, "def"
    assert_token tokens[14], :do, "do"
    assert_token tokens[16], :end, "end"
  end

  def test_keyword_tokenization_3
    @sf.stubs(:source).returns("else elsif ensure for false if in module")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 15, tokens.size
    assert_token tokens[0], :else, "else"
    assert_token tokens[2], :elsif, "elsif"
    assert_token tokens[4], :ensure, "ensure"
    assert_token tokens[6], :for, "for"
    assert_token tokens[8], :false, "false"
    assert_token tokens[10], :if, "if"
    assert_token tokens[12], :in, "in"
    assert_token tokens[14], :module, "module"
  end

  def test_keyword_tokenization_4
    @sf.stubs(:source).returns("next nil not or redo rescue retry return super")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 17, tokens.size
    assert_token tokens[0], :next, "next"
    assert_token tokens[2], :nil, "nil"
    assert_token tokens[4], :not, "not"
    assert_token tokens[6], :or, "or"
    assert_token tokens[8], :redo, "redo"
    assert_token tokens[10], :rescue, "rescue"
    assert_token tokens[12], :retry, "retry"
    assert_token tokens[14], :return, "return"
    assert_token tokens[16], :super, "super"
  end

  def test_keyword_tokenization_5
    @sf.stubs(:source).returns("then true undef unless until when while yield")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 15, tokens.size
    assert_token tokens[0], :then, "then"
    assert_token tokens[2], :true, "true"
    assert_token tokens[4], :undef, "undef"
    assert_token tokens[6], :unless, "unless"
    assert_token tokens[8], :until, "until"
    assert_token tokens[10], :when, "when"
    assert_token tokens[12], :while, "while"
    assert_token tokens[14], :yield, "yield"
  end
end
