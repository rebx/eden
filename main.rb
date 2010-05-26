$:.unshift(File.dirname(__FILE__) + "/lib")

require 'eden'
puts ARGV.inspect
sf = Eden::SourceFile.new( ARGV[0] )
sf.load!
sf.tokenize!

sf.lines.each do |line|
  print "[#{line.line_no}] "
  line.tokens.each do |t|
    print t.inspect
    print ", "
  end
  print "\n"
end
  
