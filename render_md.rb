#!/usr/bin/ruby
# Markdown sintax at http://daringfireball.net/projects/markdown/syntax

require 'rubygems'
require 'github/markup'

file = 'README.md'
result = GitHub::Markup.render(file, File.read(file))

File.open('README.html', 'w') { |f| f.write(result) }
