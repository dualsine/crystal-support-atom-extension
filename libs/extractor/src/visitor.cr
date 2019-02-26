module CrystalExtractor
  class SuperVisitor < Crystal::Visitor
    property compiler_nodes = [] of Crystal::ASTNode
    property normal_nodes = [] of Crystal::ASTNode
    private property current_nodes = "compiler"

    def process(compilation_result : Crystal::Compiler::Result, file_to_process_filename : String)
      process_type compilation_result.program

      # compilation_result.program.file_modules.each do |file_module|
      #   puts "file_module:#{file_module}"
      # end

      # puts "compilation_result.program.file_module? file_to_process_filename"
      # puts file_to_process_filename
      # puts compilation_result.program.file_module? file_to_process_filename

      # puts "file_to_process_filename"
      # puts file_to_process_filename
      # puts compilation_result.program.file_module? file_to_process_filename
      if file_module = compilation_result.program.file_module? file_to_process_filename
        # puts "process_type ---- #{file_to_process_filename}"
        process_type file_module
      end

      @current_nodes = "normal"
      compilation_result.node.accept self
    end

    def visit(node : Crystal::Nop | Crystal::Expressions | Crystal::NilLiteral | Crystal::BoolLiteral | Crystal::NumberLiteral | 
      Crystal::CharLiteral | Crystal::StringLiteral | Crystal::StringInterpolation | Crystal::SymbolLiteral | Crystal::ArrayLiteral | 
      Crystal::HashLiteral | Crystal::NamedTupleLiteral | Crystal::RangeLiteral | Crystal::RegexLiteral | Crystal::TupleLiteral | 
      Crystal::Var | Crystal::Block | Crystal::Call | Crystal::NamedArgument | Crystal::If | Crystal::Unless | Crystal::Assign | 
      Crystal::OpAssign | Crystal::MultiAssign | Crystal::InstanceVar | Crystal::ReadInstanceVar | Crystal::ClassVar | Crystal::Global | 
      Crystal::And | Crystal::Or | Crystal::Arg | Crystal::ProcNotation | Crystal::Def | Crystal::Macro |  Crystal::Not | Crystal::PointerOf | 
      Crystal::SizeOf | Crystal::InstanceSizeOf | Crystal::Out | Crystal::VisibilityModifier | Crystal::IsA | Crystal::RespondsTo | 
      Crystal::Require | Crystal::When | Crystal::Case | Crystal::Select | Crystal::ImplicitObj | Crystal::Path | Crystal::ClassDef | 
      Crystal::ModuleDef | Crystal::AnnotationDef | Crystal::While | Crystal::Until | Crystal::Generic | Crystal::TypeDeclaration | 
      Crystal::UninitializedVar | Crystal::Rescue | Crystal::ExceptionHandler | Crystal::ProcLiteral | Crystal::ProcPointer | Crystal::Union | 
      Crystal::Self | Crystal::Return | Crystal::Break | Crystal::Next | Crystal::Yield | Crystal::Include | Crystal::Extend | Crystal::LibDef | 
      Crystal::FunDef | Crystal::TypeDef | Crystal::CStructOrUnionDef | Crystal::EnumDef | Crystal::ExternalVar | Crystal::Alias | 
      Crystal::Metaclass | Crystal::Cast | Crystal::NilableCast | Crystal::TypeOf | Crystal::Annotation | Crystal::MacroExpression | 
      Crystal::MacroLiteral | Crystal::MacroVerbatim | Crystal::MacroIf | Crystal::MacroFor | Crystal::MacroVar | Crystal::Underscore | 
      Crystal::Splat | Crystal::DoubleSplat | Crystal::MagicConstant | Crystal::Asm | Crystal::AsmOperand)

      
      if node.location && node.location.not_nil!.between?(CrystalExtractor.start_location, CrystalExtractor.end_location)
        # puts node.class
        # puts node.location if node.location
        # puts node.location.not_nil!.between?(CrystalExtractor.start_location, CrystalExtractor.end_location) if node.location
        
        if current_nodes == "compiler"
          @compiler_nodes << node
        elsif current_nodes == "normal"
          @normal_nodes << node
        end
      # elsif node.location
      #   puts "node.location.not_nil!.between?(CrystalExtractor.start_location, CrystalExtractor.end_location)"
      #   puts "node.class:#{node.class}"
      #   puts "node.location:#{node.location}"
      #   puts "CrystalExtractor.start_location:#{CrystalExtractor.start_location}"
      #   puts "CrystalExtractor.end_location:#{CrystalExtractor.start_location}"
      #   puts node.location.not_nil!.between?(CrystalExtractor.start_location, CrystalExtractor.end_location)
      #   puts "................................"
      end
      true
    end

    private def process_type(type : Crystal::Type) : Nil
      if type.is_a?(Crystal::NamedType) || type.is_a?(Crystal::Program) || type.is_a?(Crystal::FileModule)
        type.types?.try &.each_value do |inner_type|
          process_type inner_type
        end
      end

      if type.is_a?(Crystal::GenericType)
        type.generic_types.each_value do |instanced_type|
          process_type instanced_type
        end
      end

      process_type type.metaclass if type.metaclass != type

      if type.is_a?(Crystal::DefInstanceContainer)
        type.def_instances.each_value do |typed_def|
          typed_def.accept self
        end
      end
    end

    def visit(node : Crystal::ASTNode)
      # true: we want to the visitor to visit node's children
      true
    end
  end
end