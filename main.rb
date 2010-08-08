$:.unshift(File.dirname(__FILE__) + "/lib")

require 'optparse'
require 'eden'

# Automatically load all the formatters
formatters = []

# Taken from ActiveSupport
def camelize(lower_case_and_underscored_word, first_letter_in_uppercase = true)
  if first_letter_in_uppercase
    lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
  else
    lower_case_and_underscored_word.first.downcase + camelize(lower_case_and_underscored_word)[1..-1]
  end
end

# Load all the formatters
Dir.glob([File.dirname(__FILE__) + "/lib/eden/formatters/*.rb"] ) do |file|
  require "#{file}"
  const_name = camelize( File.basename(file, ".rb"))
  formatters << Object.const_get( const_name )
end

# Setup defaults
require 'eden/defaults'

# Displays a source file on STDOUT using ANSI escape codes for
# syntax highlighting
def colorize( sf )
  sf.lines.each do |line|
    print "[#{line.line_no}] "
    line.tokens.flatten.each do |t|
      case t.type
      when :regex
        print "\033[32m"
        print t.content
        print "\033[0m"
      when :double_q_string, :single_q_string
        print "\033[0;36m" + t.content + "\033[0m"
      when :symbol
        print "\033[31m" + t.content + "\033[0m"
      when :instancevar
        print "\033[1;34m" + t.content + "\033[0m"
      when :comment
        print "\033[1;30m" + t.content + "\033[0m"
      else
        if t.keyword?
          print "\033[33m" + t.content + "\033[0m"
        else
          print t.content
        end
      end
    end
  end
end

# Load default options
options = {}

# Command-line options parser
opts = OptionParser.new do |opts|
  options[:recurse] = false
  opts.on('-R', '--recursive', "Recursively search subdirectories") do 
    options[:recurse] = true
  end
end

source_files = []

# Parse the command line, and find out what we want to do
opts.parse!
cmd = ARGV.shift.downcase.to_sym

unless [:colorize, :analyse, :rewrite].include?(cmd)
  puts opts
end

if File.exist?(ARGV[0]) && File.directory?(ARGV[0])
  pattern = ARGV[0] + "*.rb"
else
  pattern = ARGV[0]
end

begin
  Dir[pattern].each do |f|
    sf = Eden::SourceFile.new( f )
    sf.load!
    sf.tokenize!
    formatters.each do |formatter|
      formatter.format( sf )
    end
    source_files << sf
    case cmd
    when :colorize then colorize( sf )
    when :rewrite then sf.rewrite!
    when :analyse then analyse( sf )
    end
  end
rescue => e
  puts e
end


