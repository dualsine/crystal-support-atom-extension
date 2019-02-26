class SuperVisitor < Crystal::Visitor
  property number_nodes = [] of Crystal::ASTNode
  property all_nodes = [] of Crystal::ASTNode

  def initialize
  end

  # def visit(node : Crystal::)

  def visit(node : Crystal::NumberLiteral)
    number_nodes << node
  end

  def visit(node : Crystal::ASTNode)
    all_nodes << node
    true
  end
end