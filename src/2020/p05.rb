class Year2020::P05
  def run
    res = 0
    data = {}
    File.foreach("data/p05.txt") do |line|
      row = line[0..6].tr("FB","01").to_i(2)
      col = line[7..-1].tr("LR","01").to_i(2)
      seat_id = row * 8 + col
      res = seat_id if seat_id > res
    end

    puts "found #{res} max seat id"
  end
end