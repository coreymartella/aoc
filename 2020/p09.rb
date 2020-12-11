require_relative './common'
class P09
  include Singleton
  class << self
    extend Forwardable
    def_delegators :instance, :run
  end

  attr_reader :values, :preamble
  def initialize
    @values = File.readlines("data/p09.txt").map(&:to_i)
    @preamble = []
  end

  def run
    values.each_with_index do |val,i|
      if preamble.size < 25
        preamble << val
        next
      end
      found = false
      preamble.each_with_index do |v1,i1|
        preamble[i1+1..-1].each do |v2|
          if v1 + v2 == val
            found = true
            break
          end
        end
        break if found
      end
      if !found
        @invalid = val
        break
      end
      preamble.shift
      preamble << val
    end

    values.each_with_index do |val,i|
      remainder = @invalid
      j = i
      while remainder > 0
        remainder -= values[j]
        break if remainder == 0
        j += 1
      end

      if remainder == 0 && j > i
        subset = values[i..j].sort
        puts "found continuous sum from #{i}..#{j}: #{subset.first+subset.last}"
        break
      end
    end
  end
end
