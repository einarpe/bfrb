# RAMChip class
# part of ruby brainfuck
# @author kubar3k

class RAMChip
  attr_accessor :index
  attr_reader :size, :mem

  # constructor
  # @param size size of memory in bytes
  def initialize(size)
    @mem = []
    @index = 0
    size.times { |i| @mem[i] = 0}
    @size = size
  end

  # get current value of memory which is value at current index 
  def value
    @mem[@index]
  end

  # set value at current index
  # @param val new value
  def value=(val)
    @mem[@index] = val
  end
  
  # index operator
  # @param i index to set
  # @return value at given index
  def [](i)
    @mem[i]
  end
end
