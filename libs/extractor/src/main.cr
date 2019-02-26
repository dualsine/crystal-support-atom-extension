require "compiler/crystal/**"

class Crystal::ASTNode
  def expressions; end
end

require "./utils"
require "./visitor"
require "./crystal_extractor"
require "./macros_transformer"

if ARGV.size < 2
  puts "no entry file or file to process specfied"
  exit 0
end

CrystalExtractor.start