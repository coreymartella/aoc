trees = 0
col = 0
data = {
 {row: 1, col: 1} => {row: 0, col: 0, trees: 0},
 {row: 1, col: 3} => {row: 0, col: 0, trees: 0},
 {row: 1, col: 5} => {row: 0, col: 0, trees: 0},
 {row: 1, col: 7} => {row: 0, col: 0, trees: 0},
 {row: 2, col: 1} => {row: 0, col: 0, trees: 0},
}
File.readlines("data/p03.txt").each_with_index do |line, line_num|
  line.strip!
  data.each do |offset,status|
    if status[:row] == line_num
      char = line[status[:col] % line.size, 1]
      status[:trees] += char == "#" ? 1 : 0
      status[:col] += offset[:col]
      status[:row] += offset[:row]
    end
  end
end
puts "data #{data}"
puts "total trees: #{data.values.map{|h| h[:trees]}.reduce(:*)}"
