$: << File.dirname(__FILE__) + "/../test"
require 'test_helper'

class IdentifierTokenTest < Test::Unit::TestCase
  def setup
    @sf = Eden::SourceFile.new( "dummy.rb" )
  end

  def test_instance_var__tokenization
    @sf.stubs(:source).returns("@@token @@_token @@token2")
    @sf.tokenize!
    tokens = @sf.lines[0].tokens
    assert_equal 5, tokens.size
    assert_token tokens[0], :classvar, "@@token"
    assert_token tokens[2], :classvar, "@@_token"
    assert_token tokens[4], :classvar,  "@@token2"
  end
end
