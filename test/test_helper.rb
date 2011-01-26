lib_dir = File.dirname(__FILE__) + '/../lib'
require 'rubygems'
require 'test/unit'
require 'mocha'

$:.unshift lib_dir unless $:.include?(lib_dir)
require 'eden'

Dir.glob([File.dirname(__FILE__) + "/..//lib/eden/formatters/*.rb"] ) do |file|
  require "#{file}"
end

require 'eden/defaults'

class Test::Unit::TestCase
  def assert_token token, type, content = nil
    assert_equal type, token.type
    if content
      assert_equal content, token.content
    end
  end
end
