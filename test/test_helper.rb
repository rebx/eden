lib_dir = File.dirname(__FILE__) + '/../lib'
require 'rubygems'
require 'test/unit'
require 'mocha'
$:.unshift lib_dir unless $:.include?(lib_dir)
require 'eden'
