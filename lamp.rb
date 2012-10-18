require 'yaml/store'

class Lamp

  def self.create_database
    db = YAML::Store.new('lamps_db.yaml')
    db.transaction do
      if db['count'].nil? || db['count'].zero?
        db['count'] = 0
        db['next_id'] = 0
        db['all_ids'] = []
      end
    end
    db
  end

  @@db ||= Lamp.create_database

  attr_reader :id
  attr_accessor :quantity, :price

  def initialize(name, price, quantity)
    @name = name
    @price = price
    @quantity = quantity
  end

  def self.create(*args)
    Lamp.new(*args).save
  end

  def destroy
    @@db.transaction do
      if @id.nil?
        raise "Cannot delete Lamp that is not persisted!"
      end

      @@db.delete(@id)
      ids = @@db['all_ids']
      ids.delete(@id)
      @@db['all_ids'] = ids
      @@db['count'] -= 1
    end
    @id = nil
    self
  end

  def save
    @@db.transaction do
      if @id.nil?
       @id = @@db['next_id']
       @@db['all_ids'] << @id
       @@db['next_id'] += 1
       @@db['count'] += 1
     end
     @@db[@id] = self
    end
    self
  end

  def self.count
    @@db.transaction do
      @@db['count'] || 0
    end
  end

  def self.all
    @@db.transaction do
      @@db['all_ids'].map do |id|
        @@db[id]
      end
    end
  end

  def self.find(id)
    @@db.transaction do
      item = @@db[id]
      raise "Could not find Lamp##{id}!" if item.nil?
      item
    end
  end

  def to_s
    @name.to_s.capitalize
  end
end
