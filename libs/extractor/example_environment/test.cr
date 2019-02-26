require "compiler/crystal/syntax"

# require "./macros"
require "./camera"
require "./visitor"

macro methods
  "{{ @type.methods.map &.name.stringify }}"
end

class Crystal::ASTNode
  def methods
    methods
  end
end

code = <<-CODE
#{ File.read(ARGV[0]) }
CODE

puts code

nodes = Crystal::Parser.parse(code)

visitor = SuperVisitor.new
nodes.accept visitor
puts visitor.all_nodes.size

visitor.all_nodes.each do |node|
  puts node.class
  puts node.location
  # puts node.methods
end

# cam = Camera.new