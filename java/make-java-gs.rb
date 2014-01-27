#!/usr/bin/ruby

# This script generates an empty Java file for a given class.
#
# Author:: Kevin Litwack

require 'optparse'


SCRIPT_NAME = File.basename($0)

MATCH = /(\W*)getset ([a-zA-Z0-9\$_]*(?:<.*>)?) (.*);/

# Parse command-line options.
opts = OptionParser.new do |opts|
  opts.banner = "Usage: #{SCRIPT_NAME} [options] <Java files...>"
  opts.on('-i', "--input FILE", "Specify a file to use as input (otherwise stdin is used)") { |v| $input = v }
  opts.on('-o', "--output FILE", "Specify a file to use as output (otherwise stdout is used)") { |v| $output = v }
  opts.on('-v', "--verbose", "Show detailed processing information") { $verbose = true }
  opts.on('-h', "--help", "Display usage information") { puts opts; exit }
  opts.separator ""
  opts.separator "Example:"
  opts.separator "#{SCRIPT_NAME} Bean.java"
end
opts.parse!

# Reports a failure message and exits with an optional code.
def fail(msg, code=1)
  STDERR.puts msg
  exit code
end

# Logs a message to stderr if the verbose flag is set.
def log(msg)
  STDERR.puts msg if $verbose
end

# If an input was specified but no output was specified, output to the input.
$output = $input if $input && $output.nil?

def insert_getters_and_setters(lines)
  newlines = []
  lines.each do |line|
    line.gsub!(/\n/,"")
    if match = line.match(MATCH);
      indent, type, name = match.captures
      initial_caps_name = name.slice(0,1).capitalize + name.slice(1..-1)
      puts "    // NOCHECKIN: Matched type='#{type}' and name='#{name}'" if $verbose
      newlines << "#{indent}/**"
      newlines << "#{indent} * Gets #{name}."
      newlines << "#{indent} *"
      newlines << "#{indent} * @return the current value of #{name}."
      newlines << "#{indent} */"
      newlines << "#{indent}public #{type} get#{initial_caps_name}() {"
      newlines << "#{indent * 2}return #{name};"
      newlines << "#{indent}}"
      newlines << ""
      newlines << "#{indent}/**"
      newlines << "#{indent} * Sets #{name}."
      newlines << "#{indent} *"
      newlines << "#{indent} * @param #{name} the new value of #{name}."
      newlines << "#{indent} */"
      newlines << "#{indent}public void set#{initial_caps_name}(final #{type} #{name}) {"
      newlines << "#{indent * 2}this.#{name} = #{name};"
      newlines << "#{indent}}"
      newlines << ""
    else
      newlines << line
    end
  end
  newlines
end

# Read the input.
if $input
  in_file = File.new($input, 'r')
else
  in_file = $stdin
end
lines = in_file.readlines

# Output the converted lines.
if $output
  out_file = File.new($output, 'w')
else
  out_file = $stdout
end
out_file.puts insert_getters_and_setters(lines)
