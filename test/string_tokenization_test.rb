require File.dirname(__FILE__) + "/test_helper.rb"

class StringTokenizationTest < Test::Unit::TestCase
  def setup
    @sf = Eden::SourceFile.new( "dummy.rb" )
  end

  def test_single_quote_string_tokenisation
    @sf.stubs(:source).returns("'test' 'te\\'st' 'te\\\\st' 'te\"st'")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 7, tokens.size
    assert_token tokens[0], :single_q_string, "'test'"
    assert_token tokens[2], :single_q_string, "'te\\'st'"
    assert_token tokens[4], :single_q_string, "'te\\\\st'"
    assert_token tokens[6], :single_q_string, "'te\"st'"
  end

  def test_backquote_string_tokenisation
    @sf.stubs(:source).returns("`exec`")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 1, tokens.size
    assert_token tokens[0], :backquote_string, "`exec`"
  end

  def test_backquote_string_interpolation
    @sf.stubs(:source).returns("`exec \#\{\"cmd\"\}`")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 5, tokens.size
    assert_token tokens[0],:backquote_string, "`exec \#"
    assert_token tokens[1], :lcurly
    assert_token tokens[2], :double_q_string,"\"cmd\""
    assert_token tokens[3], :rcurly
    assert_token tokens[4], :backquote_string, "`"
  end

  def test_should_tokenize_unterminated_backquote_string
    @sf.stubs(:source).returns("`exec")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 1, tokens.size
    assert_token tokens[0], :backquote_string, "`exec"
  end

  def test_double_quote_string_tokenisation
    @sf.stubs(:source).returns('"test" "end')
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 3, tokens.size
    assert_token tokens[0], :double_q_string, '"test"'
    assert_token tokens[2], :double_q_string, '"end'
  end

  def test_double_quote_string_escaping
    @sf.stubs(:source).returns('"te\\"st" "test\\\\test"')
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 3, tokens.size
    assert_token tokens[0], :double_q_string, '"te\\"st"'
    assert_token tokens[2], :double_q_string, '"test\\\\test"'
  end

  def test_quoted_expanded_literal_string_tokenization
    @sf.stubs(:source).returns("%(test)\n%Q(test)")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 2, tokens.size
    assert_token tokens[0], :double_q_string, "%(test)"
    tokens = @sf.lines[1].tokens
    assert_token tokens[0], :double_q_string, "%Q(test)"
  end

  def test_should_expand_expanded_literal_strings
    @sf.stubs(:source).returns("%Q(rah\#{@ivar}rah)")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 5, tokens.size
    assert_token tokens[0], :double_q_string, "%Q(rah\#"
    assert_token tokens[1], :lcurly
    assert_token tokens[2], :instancevar,  "@ivar"
    assert_token tokens[3], :rcurly
    assert_token tokens[4], :double_q_string, "rah)"
  end

  def test_should_not_expand_non_expanded_literal_strings
    @sf.stubs(:source).returns("%q(rah\#{@ivar}rah)")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 1, tokens.size
    assert_token tokens[0], :single_q_string,"%q(rah\#{@ivar}rah)"
  end
  
  def test_double_quote_string_interpolation
    @sf.stubs(:source).returns("\"str\#{ @inst }str\"")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 7, tokens.size
    assert_token tokens[0], :double_q_string,'"str#'
    assert_token tokens[1], :lcurly
    assert_token tokens[3], :instancevar, '@inst'
    assert_token tokens[5], :rcurly
    assert_token tokens[6], :double_q_string, 'str"'
  end

  def test_string_interpolation_at_end
    @sf.stubs(:source).returns("\"str\#{ @inst }\"\n")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 8, tokens.size
    assert_token tokens[0], :double_q_string, '"str#'
    assert_token tokens[6], :double_q_string, '"'
  end

  def test_string_interpolation_with_class_instance_vars
    @sf.stubs(:source).returns("\"str\#@inst moar \#@@var\"\n")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 6, tokens.size
    assert_token tokens[0], :double_q_string, '"str#'
    assert_token tokens[1], :instancevar, '@inst'
    assert_token tokens[2], :double_q_string, ' moar #'
    assert_token tokens[3], :classvar, '@@var'
    assert_token tokens[4], :double_q_string, '"'
  end

  def test_string_interpolation_with_global_vars
    @sf.stubs(:source).returns("\"str\#$1\"\n")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 4, tokens.size
    assert_token tokens[0], :double_q_string, '"str#'
    assert_token tokens[1], :globalvar, '$1'
    assert_token tokens[2], :double_q_string, '"'
  end
  
  def test_delimited_backquote_string_tokenization
    @sf.stubs(:source).returns("%x{rah --e}")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 1, tokens.size
    assert_token tokens[0], :backquote_string, "%x{rah --e}"
  end

  def test_should_expand_backquote_string_delimited_literals
    @sf.stubs(:source).returns("%x(rah\#{@rah})")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 5, tokens.size
    assert_token tokens[0], :backquote_string, "%x(rah\#"
    assert_token tokens[1], :lcurly
    assert_token tokens[2], :instancevar, "@rah"
    assert_token tokens[3], :rcurly
    assert_token tokens[4], :backquote_string, ")"
  end

  def test_heredoc_tokenization
    @sf.stubs(:source).returns("str = <<HEREDOC\nLorem Ipsum\nHEREDOC\n")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 6, tokens.size
    assert_token tokens[4], :heredoc_delimiter, "<<HEREDOC"
    tokens = @sf.lines[1].tokens
    assert_token tokens[0], :heredoc_body, "Lorem Ipsum\nHEREDOC"
    assert_token tokens[1], :newline
  end

  def test_heredoc_tokenization_2
    @sf.stubs(:source).returns("str = <<-HEREDOC\nLorem Ipsum\nHEREDOC\n")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 6, tokens.size
    assert_token tokens[4], :heredoc_delimiter, "<<-HEREDOC"
    tokens = @sf.lines[1].tokens
    assert_token tokens[0], :heredoc_body, "Lorem Ipsum\nHEREDOC"
    assert_token tokens[1], :newline
  end

  # Because the heredoc delimiter must be on a line by itself, the heredoc
  # delimiter can appear in the heredoc itself without terminating it.
  def test_heredoc_tokenization_with_amgibuous_delimiter
    @sf.stubs(:source).returns(<<-SOURCE)
var = <<WARNING
WARNING Blah Blah Blah
And something more
WARNING
SOURCE
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 6, tokens.size
    assert_token tokens[4], :heredoc_delimiter, "<<WARNING"
    tokens = @sf.lines[1].tokens
    assert_equal 2, tokens.size
    assert_token tokens[0], :heredoc_body, "WARNING Blah Blah Blah\nAnd something more\nWARNING"
  end

  def test_heredoc_tokenization_empty_heredoc
    @sf.stubs(:source).returns("str = <<-HEREDOC\nHEREDOC\n")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 6, tokens.size
    assert_token tokens[4], :heredoc_delimiter, "<<-HEREDOC"
    tokens = @sf.lines[1].tokens
    assert_token tokens[0], :heredoc_body, "HEREDOC"
    assert_token tokens[1], :newline
  end
  
  def test_heredoc_tokeniztion_with_single_quote_delimiter
    @sf.stubs(:source).returns("str = <<'HERE DOC'\nLorem Ipsum\n'HERE DOC'\n")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 6, tokens.size
    assert_token tokens[4], :heredoc_delimiter, "<<'HERE DOC'"
    tokens = @sf.lines[1].tokens
    assert_token tokens[0], :heredoc_body, "Lorem Ipsum\n'HERE DOC'"
    assert_token tokens[1], :newline
  end

  def test_heredoc_tokeniztion_with_double_quote_delimiter
    @sf.stubs(:source).returns("str = <<\"HERE DOC\"\nLorem Ipsum\n\"HERE DOC\"\n")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 6, tokens.size
    assert_token tokens[4], :heredoc_delimiter, "<<\"HERE DOC\""
    tokens = @sf.lines[1].tokens
    assert_token tokens[0], :heredoc_body, "Lorem Ipsum\n\"HERE DOC\""
    assert_token tokens[1], :newline
  end

  def test_heredoc_tokeniztion_with_backquote_delimiter
    @sf.stubs(:source).returns("str = <<`HERE DOC`\nLorem Ipsum\n`HERE DOC`\n")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 6, tokens.size
    assert_token tokens[4], :heredoc_delimiter,"<<`HERE DOC`"
    tokens = @sf.lines[1].tokens
    assert_token tokens[0], :heredoc_body, "Lorem Ipsum\n`HERE DOC`"
    assert_token tokens[1], :newline
  end
end
