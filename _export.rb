#!/usr/bin/env ruby

require 'json'

file = ARGV.first || Dir.glob(File.expand_path('~/Desktop/stylus-*.json')).first
abort 'JSON file does not exist.' if file.nil? || !File.exist?(file)

json = JSON.load(File.read(file))

json.each do |style|
  name = style['name']
  next if name.nil?

  File.open("./#{name.gsub(/[ \/]/, '_')}.user.css", 'w', 0644) do |fp|
    fp.puts "/* #{name} */"
    fp.puts '@namespace url("http://www.w3.org/1999/xhtml");'

    style['sections'].each do |section|
      fp.puts

      rules = []
      rules += section['urls'].map {|url| "url(\"#{url}\")" } unless section['urls'].nil?
      rules += section['urlPrefixes'].map {|url| "url-prefix(\"#{url}\")" } unless section['urlPrefixes'].nil?
      rules += section['domains'].map {|dom| "domain(\"#{dom}\")" } unless section['domains'].nil?
      rules += section['regexps'].map {|reg| "regexp(\"#{reg}\")" } unless section['regexps'].nil?

      if rules.count > 0
        fp.print '@-moz-document'

        if rules.count > 1
          fp.puts
          fp.puts rules.map{|rule| '  ' + rule }.join(",\n")
          fp.puts '{'
        else
          fp.puts " #{rules.first} {"
        end
      end

      indent = rules.count > 0 ? '  ' : ''
      section['code'].each_line {|line|
        fp.puts line.strip.empty? ? '' : indent + line.rstrip
      }

      fp.puts '}' if rules.count > 0
    end
  end
end

File.delete(file)
