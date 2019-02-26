macro load_property(name, type, def_val)
	macro temp(name, type, def_val)
		{{ read_file("./property.tcr").id }}
	end
	temp({{name}}, {{type}}, {{def_val}})
end

macro test_macro
	puts "gonzales"
end
