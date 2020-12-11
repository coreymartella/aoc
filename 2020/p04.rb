res = 0
data = {}
required = %w(byr iyr eyr hgt hcl ecl pid)
File.foreach("data/p04.txt") do |line|
  line.strip!
  if line == ""
    res += 1 if required.all?{|k| data[k]}
    data = {}
    next
  end
  line.scan(/(\S+):(\S+)/).each do |k,v|
    data[k] = v
  end
end
res += 1 if required.all?{|k| data[k]}

puts "found #{res} valid passports"
