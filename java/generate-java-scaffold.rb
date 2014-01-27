#!/usr/bin/ruby

# This script generates an empty Java file for a given class.
#
# Author:: Kevin Litwack

require 'optparse'


SCRIPT_NAME = File.basename($0)

$importApache = false
$importIO = false
$importUtil = false
$isTest = false
$print = false

# Parse command-line options.
opts = OptionParser.new do |opts|
  opts.banner = "Usage: #{SCRIPT_NAME} [options] <Java files...>"
  opts.on('-a', "--apache", "Include apache commons imports") { $importApache = true }
  opts.on('-i', "--io", "Include java.io imports") { $importIO = true }
  opts.on('-u', "--util", "Include java.util imports") { $importUtil = true }
  opts.on('-t', "--test", "Indicates that this is a test file") { $isTest = true }
  opts.on('-p', "--print", "Print to STDOUT rather than [classname].java") { $print = true }
  opts.on('-v', "--verbose", "Show detailed processing information") { $verbose = true }
  opts.on('-h', "--help", "Display usage information") { puts opts; exit }
  opts.separator ""
  opts.separator "Example:"
  opts.separator "#{SCRIPT_NAME} TestClass"
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

# Require exactly one source argument.
fail opts if ARGV.size != 1
class_name = ARGV.shift

# Define constants.
COPYRIGHT = "/* Copyright 2013 Amazon.com, Inc. All rights reserved. */"

PACKAGE = "package com.amazon.eml.NOCHECKIN;"

JAVA_IO_IMPORTS = <<eos
import java.io.File;
import java.io.InputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.Reader;
import java.io.Writer;

eos

JAVA_UTIL_IMPORTS = <<eos
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

eos

SCAFFOLD_IMPORT = <<eos
import com.amazon.eml.NOCHECKIN;

eos

APACHE_IMPORTS = <<eos
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.Validate;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

eos

TEST_IMPORTS = <<eos
import static org.easymock.EasyMock.*;
import static org.hamcrest.Matchers.*;
import static org.junit.Assert.*;
import org.junit.*;

eos

CLASS_HEADER_COMMENT = <<eos
/**
 * NOCHECKIN: Describe class.
 *
 * @author Kevin Litwack (litwackk@amazon.com)
 */
eos

CLASS_DEFINITION = "public class #{class_name} {"

LOGGER = <<eos
    /** Logger for #{class_name}. */
    private static final Log LOG = LogFactory.getLog(#{class_name}.class);
eos

DEFAULT_CONSTRUCTOR = <<eos
    /**
     * NOCHECKIN: Describe constructor.
     */
    public #{class_name}() {

    }
eos

def section_header(name)
  "    ///// #{name} /////"
end

def section(name)
  result = [section_header(name)]
  result << ""
  result << yield
  result.concat((0...3).map {""})
end

def properties_section
  section("PROPERTIES") do
    <<eos
    /** NOCHECKIN */
    private String NOCHECKIN;
eos
  end
end

def setup_cleanup_section
  section("SETUP & CLEANUP") do
    <<eos
    @Before
    public void setup() throws Exception {
    }

    @After
    public void cleanup() throws Exception {
    }
eos
  end
end

def tests_section(type, annotation=nil)
  section("#{type} TESTS") do
    <<eos
    @Test#{annotation ? "(" + annotation + ")" : ""}
    public void NOCHECKIN() throws Exception {
    }
eos
  end
end

def constants_section
  section("CONSTANTS") do
    <<eos
#{LOGGER}
    /** NOCHECKIN */
    private static final String NOCHECKIN = "NOCHECKIN";
eos
  end
end

def initialization_section
  section("INITIALIZATION") do
    DEFAULT_CONSTRUCTOR
  end
end

def public_methods_section
  section("PUBLIC METHODS") do
    ""
  end
end

def private_methods_section
  section("PRIVATE METHODS") do
    ""
  end
end

def generate_java(f=$stdout)
  f.puts COPYRIGHT
  f.puts
  f.puts PACKAGE
  2.times {f.puts}
  f.puts JAVA_IO_IMPORTS if $importIO
  f.puts JAVA_UTIL_IMPORTS if $importUtil
  f.puts SCAFFOLD_IMPORT
  f.puts APACHE_IMPORTS if $importApache
  f.puts TEST_IMPORTS if $isTest
  f.puts
  f.puts CLASS_HEADER_COMMENT
  f.puts CLASS_DEFINITION
  f.puts
  if $isTest
    f.puts constants_section
    f.puts properties_section
    f.puts setup_cleanup_section
    f.puts tests_section("POSITIVE")
    f.puts tests_section("NEGATIVE", "expected=NOCHECKIN.class")
  else
    f.puts constants_section
    f.puts properties_section
    f.puts initialization_section
    f.puts public_methods_section
    f.puts private_methods_section
  end
  f.puts
  f.puts "}"
end

if $print
  generate_java
else
  generate_java(File.open("#{class_name}.java", 'w'))
end
