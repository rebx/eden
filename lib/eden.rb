require 'eden/token'
require 'eden/tokenizer'
require 'eden/source_file'
require 'eden/line'

require 'eden/formatter'

# Require all formatters
Dir.open( File.dirname(__FILE__) + "/eden/formatters" ) do |d|
  d.each do |file|
    require "eden/formatters/#{file}" if file =~ /\.rb$/i
  end
end

# Setup defaults
require 'eden/defaults'


