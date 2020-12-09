trees = 0
col = 0
File.foreach("p3.txt") do |line|
  line.strip!
  char = line[col % line.size, 1]
  trees += char == "#" ? 1 : 0
  col += 3
end
puts "found #{trees} trees"
