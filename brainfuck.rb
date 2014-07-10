#!/usr/bin/env ruby

# encoding: utf-8
# brainfuck parser 
# @author kubar3k

require_relative 'ramchip'
require_relative 'parser'

def usage()
  print "* * * Brainfuck Interpreter in Ruby * * *\n"
  print "Kuba 'kubar3k' Porębski proudly presents to you.\n"
  print "Usage: brainfuck.rb [options]\n"
  print "Options are:\n"
  print "-m\tmemory size\n"
  print "-f\tinput file with Brainfuck source code\n"
  print "-i\tinput Brainfuck source code\n"
  print "-om\toutput memory\n"
  print "-oi\toutput memory index\n"

  print "\n"
end

def options()
  opts = { :source_code => "", :mem_size => 32, :om => false, :oi => false }
  loop {
    case ARGV[0]
      when '-i' then ARGV.shift; opts[:source_code] = ARGV.shift
      when '-m' then ARGV.shift; opts[:mem_size] = ARGV.shift.to_i
      when '-f' then ARGV.shift; opts[:source_code] = File.open(ARGV.shift).read
      when '-om' then ARGV.shift; opts[:om] = true
      when '-oi' then ARGV.shift; opts[:oi] = true  
      else break
    end
  }
  return opts
end

def results(parser, opts)
  print "[#{parser.ram.mem.join(' ') }]\n" if opts[:om]
  print "#{parser.ram.index}\n" if opts[:oi]
end


def main()
  if ARGV.length > 0

    opts = options

    m = RAMChip.new(opts[:mem_size])
    p = Parser.new(opts[:source_code], m)

    p.parse

    results(p, opts)
  else
    usage
  end
end

main