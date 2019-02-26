
module CrystalExtractor
  @@sources_array = [] of Crystal::Compiler::Source
  @@compiler = Crystal::Compiler.new

  @@entry_point_path : String = ""
  @@entry_point_filename : String = ""
  @@entry_point_code : String = ""

  @@file_to_process_path : String = ""
  @@file_to_process_filename : String = ""
  @@file_to_process_code : String = ""

  class_property! start_location : Crystal::Location?
  class_property! end_location : Crystal::Location?

  @@visitor = SuperVisitor.new

  def self.start
    CrystalExtractor.init()

    @@compiler.no_codegen = true
    @@compiler.no_cleanup = true
    @@compiler.wants_doc = true

    begin
      compiled_result = @@compiler.compile(@@sources_array, "/tmp/.crystal_expand.temp")

      @@visitor.process compiled_result, @@file_to_process_path

      # generate json output
      json_result =  CrystalExtractor.gen_json
      puts json_result
      File.write "/tmp/CrystalExtractor.json", json_result
    rescue error
      json_string = JSON.build do |json|
        json.object do
          json.field "error_class", error.class.to_s
          json.field "error", error.to_s
        end
      end
      STDERR.puts json_string
      exit 1
    end
  end

  def self.create_json_from_node(node, json, type_of_node : String)
    json.object do
      json.field "class", node.class.to_s
      json.field "location", node.location.not_nil!.to_s if node.location
      json.field "endLocation", node.end_location.not_nil!.to_s if node.end_location
      json.field "source", node_source_to_s(node)
      json.field "typeOfNode", type_of_node

      # expand if macro
      if node.class == Crystal::Call
        transformer = MacrosTransformer.new
        expanded_node = transformer.transform node

        expanded_sources_raw = [] of String

        while transformer.expanded?
          expanded_sources_raw << expanded_node.to_s

          transformer.expanded = false
          transformer.macro_calls.clear
          expanded_node = transformer.transform expanded_node
        end
        if expanded_sources_raw.size > 0
          # json.object do
            json.field "expandedSourceRaw", expanded_sources_raw.last
            json.field "expandedClass", expanded_node.class.to_s
            json.field "expandedLocation", expanded_node.location.not_nil!.to_s
            json.field "expandedSource", node_source_to_s(expanded_node)
          # end
        end
      end
    end
  end

  def self.gen_json
    json_string = JSON.build do |json|
      json.object do
        json.field "nodes" do
          json.array do
            @@visitor.normal_nodes.each_with_index do |node, node_idx|
              CrystalExtractor.create_json_from_node(node, json, "normal")
            end
            @@visitor.compiler_nodes.each_with_index do |node, node_idx|
              CrystalExtractor.create_json_from_node(node, json, "compiler")
            end
          end
        end
      end
    end
  end

  def self.init # loads source files and change CWD
    @@entry_point_path = ARGV[0]
    @@entry_point_filename = File.basename(ARGV[0])
    @@entry_point_code = File.read(ARGV[0])

    @@file_to_process_path = ARGV[1]
    @@file_to_process_filename = File.basename(ARGV[1])
    @@file_to_process_code = File.read(ARGV[1])

    load_source(@@entry_point_path, @@entry_point_code)
    load_source(@@file_to_process_path, @@file_to_process_code)

    @@start_location = Crystal::Location.new(@@file_to_process_path, 1, 1)
    @@end_location = Crystal::Location.new(@@file_to_process_path, @@file_to_process_code.lines.size, @@file_to_process_code.lines.last.size)

    new_cwd = File.dirname(@@entry_point_path)
    Dir.cd(new_cwd)
  end

  def self.load_source(path, code)
    source = Crystal::Compiler::Source.new(path, code)
    @@sources_array << source
  end
end
