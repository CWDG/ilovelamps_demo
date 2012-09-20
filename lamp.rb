class Lamp

  @@count = 0

  attr_reader :id, :price

  def initialize(name, price)
    @name = name
    @price = price

    @id = @@count
    @@count += 1
  end

  def to_s
    @name.to_s.capitalize
  end
end
