require 'analyzers/parserino'

arguments = ARGV
file = arguments[0]
debug = arguments[1]

sourceCode = Mate.new debug
sourceCode.parse arguments.first