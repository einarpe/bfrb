# RAMChip class
# part of ruby brainfuck
# @author kubar3k

class RAMChip
  attr_accessor :index
  attr_reader :size, :mem

  def initialize(size)
    @mem = []
    @index = 0
    size.times { |i| @mem[i] = 0}
    @size = size
  end

  def value
    @mem[@index]
  end

  def value=(val)
    @mem[@index] = val
  end
  
  def [](i)
    @mem[i]
  end
end
