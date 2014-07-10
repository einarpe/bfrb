# Parser class
# part of ruby brainfuck
# @author kubar3k

class Parser

  attr_reader :stack, :ram
  attr_accessor :_stdout, :_stdin
  
  # constructor
  # @param input source code of Brainfuck script
  # @param memory piece of memory of RAMChip class
  def initialize(input, memory)

    # remove non-brainfuck tokens from input and convert it to array
    @input = input.gsub(/[^,\.\[\]<>\-\+]/, "").split("")
    @ram = memory
  end

  # calling this function will read data from user
  # two ways: when assigned user-defined function or simply read from stdin
  def stdin
    if @_stdin == nil
      read = $stdin.gets.chomp
      return read != nil ? read[0].ord : 0
    else
      @_stdin.call 
    end
  end

  # calling this function will output current memory value as charater
  # two ways: when assigned user-defined function or simply put charater on stdout
  def stdout(val)
    if @_stdout == nil
      print val.chr
    else
      @_stdout.call(val)
    end
  end

  # assign stdin function
  # @param func lambda returning one char as user input
  def stdin=(func)
    @_stdin = func
  end

  # assign stdout function
  # @param func lambda returning void, accepting one char as output
  def stdout=(func)
    @_stdout = func
  end
  
  # analysis of basic structure of script
  # currently, nothing but recognise of parenthesis level
  # @return hash where keys are positions of opening brackets ([) 
  #           and values are positions of corresponding closing brackets (])
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

  # just parse and watch magic happen...
  def parse()
    analyze()
    
    position = 0
    while position < @input.length
      token = @input[position]
      position = _internal_parse(token, position)
    end
  end
  
  # parse one token which lies in script at given position
  # just decide what to do
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
  
  # performing `while` operation when opening bracket is found in script
  def _perform_while(current_positon)
    position = current_positon
    while @ram.value != 0
      position = _internal_parse(@input[position], position)
    end
    return position
  end
  
  # when `while` loop is completed, decide what to do next.
  # when current value in memory is 0, then go to next token
  # otherwise go back to corresponding opening bracket 
  def _go_back(current_positon)
    bracket = @bmap.select { |k, v| v == current_positon }.keys[0]
    return @ram.value != 0 ? bracket + 1 : current_positon + 1
  end
  
  private :_internal_parse, :_perform_while, :_go_back
end