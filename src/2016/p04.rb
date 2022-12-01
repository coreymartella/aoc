module Year2016
  class P04
    def run
      input = File.read("p04.txt").split("\n")
      sector_sum = 0
      alpha = "abcdefghijklmnopqrstuvwxyz".chars
      input.each do |room|
        name, checksum = room.split(/[\[\]]/)
        sector = room[/\-(\d+)\[/,1].to_i
        shifted = alpha.rotate(sector)
        real_name = name.tr("#{alpha.join}-",  "#{shifted.join} ")
        # puts "#{name} ==> #{real_name}"
        puts "#{real_name} @ #{sector}" if real_name =~ /pole/i
        letter_counts = name.gsub(/[^a-z]/,'').chars.histogram
        letters = letter_counts.keys.sort_by{|l| [-letter_counts[l], l]}[0..4].join
        sector_sum += sector if letters == checksum
      end
      puts "real rooms sectors: #{sector_sum}"
    end
  end
end