require_relative './common'
class P10
  attr_reader :values, :route_cache
  def initialize
    @values = File.readlines("data/p10.txt").map(&:to_i).sort
    @route_cache = {}
  end
  def run
    @output = values.pop
    count = 0
    i = 0
    while values[i] <= 3
      # puts "calculating routes for #{i}=#{values[i]}"
      count += routes(i)
      i += 1
    end
    puts "count: #{count}"
    # routes()
    # max = values.pop
    # diffs = Hash.new(0)
    # values.each_with_index do |val,i|
    #   diffs[val] += 1 if i == 0
    #   diffs[3] += 1 if !values[i+1]
    #   diffs[values[i+1]-val] += 1 if values[i+1]
    # end
    # puts "diffs #{diffs}"
    # res = diffs[1]*diffs[3]
  end

  def routes(input_index)
    route_cache[input_index] ||= begin
      next_index = input_index + 1
      count = @output - values[input_index] <= 3 ? 1 : 0
      while next_index <= values.size - 1 && values[next_index] - values[input_index] <= 3
        # puts "calculating next routes for #{input_index}=#{values[input_index]} ==> #{next_index}=#{values[next_index]}"
        count += routes(next_index)
        next_index += 1
      end
      count
    end
  end
end