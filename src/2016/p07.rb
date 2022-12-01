class Year2016::P07
  def run
    input = File.read("p07.txt").split("\n")

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
  end
end