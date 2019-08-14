class Node
  attr_reader :key
  attr_accessor :val, :next, :prev

  def initialize(key = nil, val = nil)
    @key = key
    @val = val
    @next = nil
    @prev = nil
  end

  def to_s
    "#{@key}: #{@val}"
  end

  def remove
    # optional but useful, connects previous link to next link
    # and removes self from list.

    self.prev.next, self.next.prev = self.next, self.prev
    self
  end
end

class LinkedList
  include Enumerable

  attr_reader :head, :tail

  def initialize
    @head, @tail = Node.new, Node.new
    head.next = tail
    tail.prev = head
  end

  def [](i)
    each_with_index { |link, j| return link if i == j }
    nil
  end

  def first
    head.next
  end

  def last
    tail.prev
  end

  def empty?
    count == 0
  end

  def get(key)
    node = find { |node| node.key == key }
    node && node.val
  end

  def include?(key)
    any? { |node| node.key == key}
  end

  # prev = tail.prev
  # tail.prev = new_node
  # new_node.next = tail
  def append(key, val)
    new_node = Node.new(key, val)
    new_node.prev, new_node.next = tail.prev, tail
    tail.prev.next = new_node
    tail.prev = new_node
  end

  def update(key, val)
    return unless include?(key)
    node = find { |node| node.key == key }
    node.val = val
  end

  def remove(key)
    find { |node| node.key == key }.remove
  end

  def each(&prc)
    current_node = head
    until (current_node = current_node.next) == tail
      prc.call(current_node)
    end
    self
  end

  # uncomment when you have `each` working and `Enumerable` included
  def to_s
    inject([]) { |acc, link| acc << "[#{link.key}, #{link.val}]" }.join(", ")
  end
end
