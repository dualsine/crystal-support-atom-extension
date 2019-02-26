macro fast_props(name, val)
  property {{name}} = {{val}}
end

macro initialize_macro
  puts "initialize_macro works"
end

macro test_never_called_macro
  puts "test_never_called_macro called"
end