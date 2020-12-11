require 'byebug'
data = {}
required = %w(byr iyr eyr hgt hcl ecl pid)
validators = {
  "byr" => ->(v){ (1920..2002) === v.to_i },
  "iyr" => ->(v){ (2010..2020) === v.to_i },
  "eyr" => ->(v){ (2020..2030) === v.to_i },
  "hgt" => ->(v){ (v =~ /^\d+cm$/ && (150..193) === v.to_i) || (v =~ /^\d+in$/ && (59..76) === v.to_i)},
  "hcl" => ->(v){ v =~ /^#\h{6}$/ },
  "ecl" => ->(v){ %w(amb blu brn gry grn hzl oth).include?(v) },
  "pid" => ->(v){ v =~ /^\d{9}$/ },
}
passports = []
File.foreach("data/p04.txt") do |line|
  line.strip!
  if line == ""
    passports << data
    data = {}
    next
  end
  line.scan(/(\S+):(\S+)/).each do |k,v|
    data[k] = v
  end
end
passports << data
res = passports.count{|data| validators.all?{|k,v| v.call(data[k])}}

puts "found #{res} valid passports"
