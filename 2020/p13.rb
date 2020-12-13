require_relative './common'
class P13
  N = 0

  attr_reader :data, :arrival, :bus_times, :departures, :bus_offsets
  def initialize
    @arrival,@bus_times = *File.readlines("data/p13.txt")
    @arrival = @arrival.to_i
    @bus_offsets = {}
    @bus_times = @bus_times.strip.split(",")
    @bus_times.each_with_index do |bus,i|
      @bus_offsets[bus.to_i] = i unless bus == "x"
    end
  end
  def run
    puts 'trying to satisfy'
    bus_offsets.each do |bus,offset|
      puts "(t + #{offset}) % #{bus} == 0"
    end
    start = 100000000000000
    step = 1
    bus_offsets.keys.sort.reverse_each do |bus|
      offset = bus_offsets[bus]
      while (start+offset) % bus != 0
        start += step
      end
      puts "start=#{start} bus=#{bus} offset=#{offset} step=#{step} check=#{(start+offset)%bus}"
      step = bus.lcm(step)
    end
    # big_bus = bus_offsets.keys.max
    # big_bus_offset = bus_offsets[big_bus]
    # all_ok = false

    # while !all_ok
    #   diffs = bus_offsets.map do |bus,offset|
    #     [bus,(start+offset) % bus]
    #   end
    #   printf("\rstart=%-20d " + ("   %4d=%4d"*diffs.size), start,*diffs.flatten); STDOUT.flush
    #   all_ok = diffs.map(&:second).all?(&:zero?)
    #   start += big_bus unless all_ok
    # end
    # puts "start=#{start}"
  end


  def run_a
    @departures = {}
    @bus_times.each do |bus|
      wait = arrival % bus
      next_departure = arrival + (wait == 0 ? 0 : (bus-wait))
      puts "arrival=#{arrival}; bus=#{bus}; wait=#{wait}; next_departure=#{next_departure};"
      departures[bus] = next_departure
    end
    puts "departures is #{departures}"
    next_departure = departures.values.min
    next_bus = departures.keys.detect{|k| departures[k] == next_departure}
    wait = next_departure-arrival
    puts "next_departure=#{next_departure}; next_bus=#{next_bus}; wait=#{wait}; ans=#{(next_departure-arrival)*next_bus}"
  end
end

<<-NOTES
0=>19, 9=>41, 19=>521, 27=>23, 36=>17, 48=>29, 50=>523, 56=>37, 63=>13
t such that:
(t + 0) % 19 == 0
(t + 9) % 41 == 0
(t + 19) % 521 == 0
(t +27) % 23 == 0
NOTES