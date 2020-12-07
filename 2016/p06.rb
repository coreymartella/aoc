require './common'
input = File.read("p06.txt").split("\n")
sector_sum = 0
alpha = "abcdefghijklmnopqrstuvwxyz".chars
counts = []
input.each do |word|
  # puts "word is #{word}"
  word.chars.each_with_index do |c,i|
    # puts "#{c}@#{i}"
    counts[i] ||= Hash.new(0)
    counts[i][c] += 1
  end
  # break
end
pp counts
puts counts.map{|c| c.keys.max_by{|k| c[k]}}.join
puts counts.map{|c| c.keys.min_by{|k| c[k]}}.join