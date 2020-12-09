nums = File.readlines("p1.in.txt").map(&:to_i)
h = {}
nums.each do |num|
  nums.each do |num2|
    h[num+num2] = [num,num2]
  end
end

nums.each do |num|
  if h[2020-num]
    res = h[2020-num] + [num]
    puts "found #{res} = #{res.reduce(:*)}"
    break
  end
end