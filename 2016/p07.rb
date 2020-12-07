require './common'
input = File.read("p07.txt").split("\n")
class String
  def abba?
    (cs = chars).each_with_index do |c,i|
      return true if c == cs[i+3] && cs[i+1] == cs[i+2] && c != cs[i+1]
    end
    return false
  end
  def abas
    abas = []
    (cs = chars).each_with_index do |c,i|
      abas << cs[i..i+2].join if c == cs[i+2] && c != cs[i+1]
    end
    abas.uniq
  end
  def aba?(a_char, b_char)
    (cs = chars).each_with_index do |c,i|
      return true if c == a_char && c == cs[i+2] && cs[i+1] == b_char
    end
    return false
  end
end

count = input.count do |word|
  word.scan(/\[([^\]]+)\]/).flatten.none?(&:abba?) && word.split(/\[[^\]]*\]/).any?(&:abba?)
end
puts "abba: #{count}/#{input.size}"


count = input.count do |word|
  abas = word.split(/\[[^\]]*\]/).map(&:abas).flatten.compact.uniq
  # puts "found #{abas} in #{word}"
  abas.any? && word.scan(/\[([^\]]+)\]/).flatten.any? do |anti|
    abas.any? do |aba|
      match = anti.aba?(aba.chars[1], aba.chars[0])
      puts "found #{aba} in #{anti} of #{word}" if match
      match
    end
  end
end
puts "aba: #{count}/#{input.size}"
# < 376