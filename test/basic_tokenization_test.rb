$: << File.dirname(__FILE__) + "/../test"
require 'test_helper'

class BasicTokenizationTest < Test::Unit::TestCase
  def setup
    @sf = Eden::SourceFile.new("dummy.rb")
  end

  def test_should_tokenize_linebreak_escape
    @sf.stubs(:source).returns("puts \\\n  'rah'")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 4, tokens.size
    assert_token tokens[2], :backslash
    assert_token tokens[3], :newline
  end

  def test_should_tokenize_question_mark_character_literals
    @sf.stubs(:source).returns("?a ?} ?\u2332\n")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 6, tokens.size
    assert_token tokens[0], :character_literal, "?a"
    assert_token tokens[2], :character_literal, "?}"
    assert_token tokens[4], :character_literal, "?\u2332"
  end
end
