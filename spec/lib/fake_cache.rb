class FakeCache
  attr_accessor :store

  def initialize
    @store = {}
  end

  def write key, value
    @store[key] = value
  end

  def read key
    @store[key]
  end

end