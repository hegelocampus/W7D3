require_relative 'p04_linked_list'

class HashMap
  include Enumerable
  attr_accessor :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @count = 0
  end

  def include?(key)
    !self[key].nil?
  end

  def set(key, val)
    if self.include?(key)
      @store[bucket(key)].update(key, val)
    else
      @store[bucket(key)].append(key, val)
      self.count += 1 
      resize! if count == num_buckets
    end
  end

  def get(key)
    @store[bucket(key)].get(key)
  end

  def delete(key)
    @count -= 1 if @store[bucket(key)].remove(key)
  end

  def each(&prc)
    @store.each do |bucket|
      bucket.each { |node| prc.call(node.key, node.val) }
    end
  end

  # uncomment when you have Enumerable included
  # def to_s
  #   pairs = inject([]) do |strs, (k, v)|
  #     strs << "#{k.to_s} => #{v.to_s}"
  #   end
  #   "{\n" + pairs.join(",\n") + "\n}"
  # end

  alias_method :[], :get
  alias_method :[]=, :set

  private

  def num_buckets
    @store.length
  end

  def resize!
    old_store = @store
    @count = 0
    @store = Array.new(num_buckets * 2) { LinkedList.new }
    old_store.each do |bucket|
      bucket.each { |node| set(node.key, node.val) }
    end
  end

  def bucket(key)
    # optional but useful; return the bucket corresponding to `key`
    key.hash % num_buckets
  end
end
