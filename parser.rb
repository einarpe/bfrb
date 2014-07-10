# Parser class
# part of ruby brainfuck
# @author kubar3k

class Parser

  attr_reader :stack, :ram
  attr_accessor :_stdout, :_stdin
  
  def initialize(input, memory)
    @input = input.gsub(/[^,\.\[\]<>\-\+]/, "").split("")
    @ram = memory
  end


  def stdin
    if @_stdin == nil
      read = $stdin.gets.chomp
      return read != nil ? read[0].ord : 0
    else
      @_stdin.call 
    end
  end

  def stdout(val)
    if @_stdout == nil
      print val.chr
    else
      @_stdout.call(val)
    end
  end

  def stdin=(func)
    @_stdin = func
  end

  def stdout=(func)
    @_stdout = func
  end
  
  def analyze()
    @bmap = {}
    stack = []
    @input.each_index { |i|
      c = @input[i]
      if c == "["
        stack.push i
      elsif c == "]"
        curr = stack.pop
        raise "Incorrect parenthesis!" if curr == nil
        
        @bmap[curr] = i 
      end
    }
    return @bmap
  end

  def parse()
    analyze()
    
    position = 0
    while position < @input.length
      token = @input[position]
      position = _internal_parse(token, position)
    end
  end
  
  def _internal_parse(token, current_positon)
    if token == "["
      return _perform_while(current_positon + 1)
    elsif token == "]"
      return _go_back(current_positon)
    else
      case token
        when "+" then @ram.value += 1
        when "-" then @ram.value -= 1
        when "<" then @ram.index -= 1 if @ram.index > 0
        when ">" then @ram.index += 1 if @ram.index < @ram.size - 1
        when "," then @ram.value = stdin
        when "." then stdout(@ram.value)
      end
      
      return current_positon + 1
    end
  end
  
  def _perform_while(current_positon)
    position = current_positon
    while @ram.value != 0
      position = _internal_parse(@input[position], position)
    end
    return position
  end
  
  def _go_back(current_positon)
    bracket = @bmap.select { |k, v| v == current_positon }.keys[0]
    return @ram.value != 0 ? bracket + 1 : current_positon + 1
  end
  
  private :_internal_parse, :_perform_while, :_go_back
end