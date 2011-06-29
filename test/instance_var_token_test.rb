$: << File.dirname(__FILE__) + "/../test"
require 'test_helper'

class IdentifierTokenTest < Test::Unit::TestCase
  def setup
    @sf = Eden::SourceFile.new( "dummy.rb" )
  end

  def test_instance_var_tokenization
    @sf.stubs(:source).returns("@token @_token @token2")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 5, tokens.size
    assert_token tokens[0], :instancevar, "@token"
    assert_token tokens[2], :instancevar, "@_token"
    assert_token tokens[4], :instancevar, "@token2"
  end

  # $' used as a global by Hprictot 0.6.164:lib/elements.rb[274]
  def test_global_var_tokenization
    @sf.stubs(:source).returns("$: $? $foo $1 $'")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 9, tokens.size
    assert_token tokens[0], :globalvar,  "$:"
    assert_token tokens[2], :globalvar, "$?"
    assert_token tokens[4], :globalvar,"$foo"
    assert_token tokens[6], :globalvar, "$1"
    assert_token tokens[8], :globalvar, "$'"
  end

  # $` used as a global by Hprictot 0.6.164:lib/builder.rb[199]
  def test_global_var_tokenization_2
    @sf.stubs(:source).returns("$`")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 1, tokens.size
    assert_token tokens[0], :globalvar, "$`"
  end
end
