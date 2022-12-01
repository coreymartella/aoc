class Year2020::P06b
  def run
    res = 0
    groups = []
    group = []
    File.foreach("data/p06.txt") do |line|
      person = line.strip!
      if person != ""
        group << person
      else # person == ""
        groups << group
        group = []
      end
    end
    groups << group if group != []
    group_sizes = groups.map{|group| group.map(&:chars).reduce(:&).size}
    puts "group sizes: #{group_sizes}"
    puts "found #{group_sizes.sum} sum"
  end
end