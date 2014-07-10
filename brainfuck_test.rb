#!/usr/bin/env ruby

require_relative 'ramchip'
require_relative 'parser'
require 'test/unit'

class TestParser < Test::Unit::TestCase
  @m = RAMChip.new(10)
  
  def test_analyze
    @m = RAMChip.new(8)
    
    p = Parser.new("++", @m) 
    bmap = p.analyze
    assert_equal(0, bmap.length)
    
    p = Parser.new("++[-]", @m) 
    bmap = p.analyze
    assert_equal(1, bmap.length)
    assert_equal(4, bmap[2])
    
    p = Parser.new("++++[[--]--]", @m) 
    bmap = p.analyze
    assert_equal(2, bmap.length)
    assert_equal(11, bmap[4])
    assert_equal(8, bmap[5])
    
    assert_raise (RuntimeError) {
      p = Parser.new("++++[[--]--]]", @m) 
      bmap = p.analyze
    }
  end
  
  def test_parse1
    p = Parser.new("++", RAMChip.new(8)) 
    p.parse
    assert_equal(2, p.ram[0])
    assert_equal(0, p.ram.index)
    
    p = Parser.new("+++--", RAMChip.new(8)) 
    p.parse
    assert_equal(1, p.ram[0])
    assert_equal(0, p.ram.index)
    
    p = Parser.new(">>+++--", RAMChip.new(8)) 
    p.parse
    assert_equal(0, p.ram[0])
    assert_equal(0, p.ram[1])
    assert_equal(1, p.ram[2])
    assert_equal(2, p.ram.index)
    
    p = Parser.new(">++>++", RAMChip.new(8)) 
    p.parse
    assert_equal(0, p.ram[0])
    assert_equal(2, p.ram[1])
    assert_equal(2, p.ram[2])
    assert_equal(2, p.ram.index)
  end
  
  def test_parse2
    p = Parser.new("++++[-]", RAMChip.new(8)) 
    p.parse
    assert_equal(0, p.ram[0])
    assert_equal(0, p.ram.index)
    
    p = Parser.new(">++>[<]", RAMChip.new(8)) 
    p.parse
    assert_equal(2, p.ram[1])
    assert_equal(0, p.ram[0])
    
    
  end
  
  # courtesy of wikipedia page
  def test_parse3
    
    p = Parser.new("
    +++++ +++
    [
        >++++
        [
            >++
            >+++
            >+++
            >+
            <<<<-
        ]
        >+
        >+
        >-
        >>+
        [<]
        <-
    ]", RAMChip.new(32))
    p.parse
    
    # The result of this is:
    # Cell No :   0   1   2   3   4   5   6
    # Contents:   0   0  72 104  88  32   8
    # Pointer :   ^
    
    some_mem = p.ram.mem.slice(0, 7)
    assert_equal([0, 0, 72, 104, 88, 32, 8], some_mem)

    assert_equal(0, p.ram.index)
    
    
  end
end
