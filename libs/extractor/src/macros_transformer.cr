module CrystalExtractor
  class MacrosTransformer < Crystal::Transformer
    property? expanded = false
    getter macro_calls = [] of Crystal::Call
    
    def transform(node : Crystal::Call)
      if expanded = node.expanded
        self.expanded = true
        macro_calls << node
        expanded
      else
        super
      end
    end
    
    def transform(node : Crystal::MacroFor | Crystal::MacroIf | Crystal::MacroExpression)
      if expanded = node.expanded
        self.expanded = true
        expanded
      else
        super
      end
    end
  end
end