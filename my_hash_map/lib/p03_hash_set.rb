class HashSet
  attr_reader :count

  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(num)
    return if include?(num)
    @count += 1
    self[num] << num
    resize! if count == num_buckets
  end

  def remove(num)
    @count -= 1 if self[num].delete(num) { false }
  end

  def include?(num)
    self[num].include?(num)
  end

  private

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
    @store[num.hash % num_buckets]
  end

  def num_buckets
    @store.length
  end

  def resize!
    old_store = @store.flatten
    @count = 0
    @store = Array.new(num_buckets * 2) { Array.new }
    old_store.each { |n| insert(n) }
  end
end
