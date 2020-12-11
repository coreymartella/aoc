good = 0
File.readlines("data/p02.txt").each do |line|
  low,high,char,pass = *line.scan(/(\d+)-(\d+) (.): (.*)/).flatten
  low = low.to_i - 1
  high = high.to_i - 1
  count = (pass[low] == char ? 1 : 0 ) + (pass[high] == char ? 1 : 0)
  if count == 1
    good += 1
  end
end
puts "found #{good} passwords"
