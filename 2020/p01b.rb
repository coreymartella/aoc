nums = File.readlines("data/p1.txt").map(&:to_i)
h = {}
h_comp = {}
h = {}
h_sum = {}
nums.each do |num|
  h[num] = true
  h[2020-num] = true
  nums.each do |num2|
    h_sum[num+num2] = [num,num2]
  end
end

nums.each do |num|
  if h[2020-num]
  if h_sum[2020-num]
    res = h_sum[2020-num] + [num]
    puts "found #{res} = #{res.reduce(:*)}"
    break
  end
end