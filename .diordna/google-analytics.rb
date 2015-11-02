#!/usr/bin/env ruby

#
#   Copyright 2012 Hai Bison
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

require 'open3'
require 'optparse'
require 'ostruct'
require 'pathname'

##
# Parses arguments.
#
def parse_args args=ARGV.clone
    result = OpenStruct.new

    OptionParser.new do |opts|
        opts.banner = "\n" \
                      "*** Google Analytics Handler ***"
        opts.separator ''

        opts.separator "Options:"

        opts.on('--debug', "debug mode") { result.debug = true }
    end.parse! args

    result
end # parse_args

##
# Prints separator.
#
def print_separator msg=nil
    # Print an empty line first
    puts

    # Now get terminal columns, and print the separator
    stdout, status = Open3.capture2 *['tput', 'cols']
    if status.success?
        cols = stdout.strip.to_i
        separator = '=' * [cols, 144].min
        puts separator
    end

    # Print the message if provided
    puts msg if msg
end # print_separator

##
# Adds Google Analytics script to tag `<head>` for all HTML files from given directory, *recursively*.
#
def add_google_analytics_script ga_js_full_path, dir
    # Get real paths
    dir = File.realpath dir

    Dir.foreach(dir) do |file_name|
        next if ['.', '..', '.git'].include? file_name

        file_path = File.join(dir, file_name)

        # Check if it's a directory
        if File.directory? file_path
            add_google_analytics_script ga_js_full_path, file_path
            next
        end

        # Check if it's an HTML file
        next if ! file_name.match /.+?\.html/i

        # Now read file content
        file_content = File.read file_path
        count = 0

        file_content.sub!(/<\/head>/) do |match|
            count += 1

            # Build relative path to the script
            ga_js_relative_path = ga_js_full_path.relative_path_from(Pathname.new(dir))

            "<script type=\"text/javascript\" src=\"#{ga_js_relative_path}\"></script></head>"
        end

        # Write new content to file
        File.write(file_path, file_content) if count > 0
    end # foreach
end # add_google_analytics_script

if __FILE__ == $0
    # Parse arguments
    args = parse_args

    # Add Google Analytics script
    print_separator " > HANDLING GOOGLE ANALYTICS...\n"
    dir_apidocs = File.join(File.dirname(File.dirname(File.realpath($0))), 'apidocs')
    ga_js_full_path = Pathname.new File.join(File.dirname(dir_apidocs), '.google-analytics.js')
    add_google_analytics_script ga_js_full_path, dir_apidocs

    print_separator " > DONE"
end
