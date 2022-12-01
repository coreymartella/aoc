class Year2020::P06
  def run
    res = 0
    groups = []
    group = ""
    File.foreach("data/p06.txt") do |line|
      group << line.strip!
      if line == ""
        groups << group
        group = ""
        next
      end
    end
    groups << group if group != ""

    counts = groups.map{|g| g.chars.uniq.size }
    puts "found #{counts.sum} sum"
  end
end