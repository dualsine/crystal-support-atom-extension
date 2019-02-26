class Camera
    load_property x, Float32, 0_f32
    load_property y, Float32, 0_f32
    load_property z, Float32, -30_f32

    def initialize
        test_macro
    end
end

test = Camera.new
