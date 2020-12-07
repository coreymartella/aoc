require './common'
path = "R3, L5, R2, L2, R1, L3, R1, R3, L4, R3, L1, L1, R1, L3, R2, L3, L2, R1, R1, L1, R4, L1, L4, R3, L2, L2, R1, L1, R5, R4, R2, L5, L2, R5, R5, L2, R3, R1, R1, L3, R1, L4, L4, L190, L5, L2, R4, L5, R4, R5, L4, R1, R2, L5, R50, L2, R1, R73, R1, L2, R191, R2, L4, R1, L5, L5, R5, L3, L5, L4, R4, R5, L4, R4, R4, R5, L2, L5, R3, L4, L4, L5, R2, R2, R2, R4, L3, R4, R5, L3, R5, L2, R3, L1, R2, R2, L3, L1, R5, L3, L5, R2, R4, R1, L1, L5, R3, R2, L3, L4, L5, L1, R3, L5, L2, R2, L3, L4, L1, R1, R4, R2, R2, R4, R2, R2, L3, L3, L4, R4, L4, L4, R1, L4, L4, R1, L2, R5, R2, R3, R3, L2, L5, R3, L3, R5, L2, R3, R2, L4, L3, L1, R2, L2, L3, L5, R3, L1, L3, L4, L3".split(", ")
orig = pos = [0,0]
bearings = [:N, :E, :S, :W] 
bearing = :N
locs = {pos => true}
dupe = false
path.each do |m|
  turn = m[0..0]
  count = m[1..-1].to_i
  bearing = bearings[(bearings.index(bearing) + (turn == "R" ? 1 : -1)) % bearings.size]
  count.times do 
    case bearing
    when :N
      pos = [pos[0], pos[1] + 1]
    when :E
      pos = [pos[0] + 1, pos[1]]
    when :S
      pos = [pos[0], pos[1] - 1]
    when :W
      pos = [pos[0] -1, pos[1]]
    end
    if locs[pos] && !dupe
      dist = orig.map.with_index{|v,i| (v - pos[i]).abs}.sum
      puts "already visited #{pos} which is #{dist} from home"
      dupe = true
    end
    locs[pos] = true
  end
end
dist = orig.map.with_index{|v,i| (v - pos[i]).abs}.sum
puts "dist(#{orig}, #{pos}) = #{dist}" 