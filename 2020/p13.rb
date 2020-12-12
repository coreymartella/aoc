require_relative './common'
class P13
  N = 0
  E = 1
  S = 2
  W = 3
  DIRS = {
    N => "N",
    E => "E",
    S => "S",
    W => "W",
  }
  attr_reader :data
  def initialize
    @data = File.readlines("data/p12.txt").map do |l|
      l.strip!
    end
  end
  def run
    @data.each do |line|
      print ""

      puts "POST sx=#{sx} sy=#{sy} wx=#{wx} wsy=#{wy} "
    end
    puts "finished "
  end
end