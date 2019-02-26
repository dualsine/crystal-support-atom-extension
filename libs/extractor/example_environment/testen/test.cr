macro add
    {{ 2 + 3 }}
end
class Car
  def initialize
add()
  end
end
car = Car.new
add()

