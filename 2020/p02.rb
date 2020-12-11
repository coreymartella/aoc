good = 0
File.readlines("data/p2.txt").each do |line|
  low,high,char,pass = *line.scan(/(\d+)-(\d+) (.): (.*)/).flatten
  low = low.to_i
  high = high.to_i
  count = pass.count(char)
  if low <= count &&  count <= high
    good += 1
  end
end
puts "found #{good} passwords"
