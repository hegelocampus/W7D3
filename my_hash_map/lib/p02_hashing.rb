class Integer
  # Integer#hash already implemented for you
end

class Array
  def hash
    (0...self.length).inject(0) do |acc, i|
      if self[i].is_a?(Integer)
        acc + ((i + 1) * self[i]).hash
      else
        acc + self[i].hash
      end
    end
  end
end

class String
  def hash
    self.codepoints.hash
  end
end

class Hash
  # This returns 0 because rspec will break if it returns nil
  # Make sure to implement an actual Hash#hash method
  def hash
    self.to_a.sort.hash
  end
end
