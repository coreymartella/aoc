class Year2020::P05b
  def run
    res = 0
    ids = []
    File.foreach("data/p05.txt") do |line|
      row = line[0..6].tr("FB","01").to_i(2)
      col = line[7..-1].tr("LR","01").to_i(2)
      seat_id = row * 8 + col
      ids << seat_id
    end
    ids.sort!
    puts "seat ids: #{ids}"
    ids.each_with_index do |id,i|
      if ids[i+1] && id + 2 == ids[i+1]
        puts "found missing next id #{id+1} due to gap #{id}..#{ids[i+1]}"
        break
      end
    end
  end
end