
def node_source_to_s(node : Crystal::ASTNode)
  source = ""
  if node.expressions
    node.expressions.not_nil!.each do |expr|
      if expr.class != Crystal::Macro
        source += "\n" if source.size > 0
        source += expr.to_s
      end
    end
  else
    source = node.to_s
  end
  source
end
