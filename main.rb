$:.unshift(File.dirname(__FILE__) + "/lib")

require 'eden'
puts ARGV.inspect
sf = Eden::SourceFile.new( ARGV[0] )
sf.load!
sf.tokenize!

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
  
