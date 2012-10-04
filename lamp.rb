class Lamp

  @@count = 0

  attr_reader :id, :price
  attr_accessor :quantity

  def initialize(name, price)
    @name = name
    @price = price
    @quantity = rand(10) + 7

    @id = @@count
    @@count += 1
  end

  def to_s
    @name.to_s.capitalize
  end
end
