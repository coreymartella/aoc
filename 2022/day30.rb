#!/usr/bin/env ruby
require_relative 'day'
class Day30 < Day
  # data is [], graph is {k => []}, f is {k => 0}, h is {}, result,r,c,x,y are ints
  def part1
    # debug!
    #
    # v1, v2 = *input.split("\n\n")
    each_line do |line, li|
      # v1,v2 = *line.scan[/.../].flatten
    end

    # max_iters = 10
    # 1.upto(max_iters) do |iter|
    #
    # end

    result
  end

  # def part2
  #   # debug!
  # end
end
if __FILE__ == $0
  ENV["INPUT"] = ARGV.last || __FILE__.split("/").last.gsub(".rb",'')
  Day30.new.part1
end

=begin

=end
