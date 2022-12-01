class Year2020::P07
  def run
    # light red bags contain 1 bright white bag, 2 muted yellow bags.
    # dark orange bags contain 3 bright white bags, 4 muted yellow bags.
    # bright white bags contain 1 shiny gold bag.
    # muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
    # shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
    # dark olive bags contain 3 faded blue bags, 4 dotted black bags.
    # vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
    # faded blue bags contain no other bags.
    # dotted black bags contain no other bags.

    res = 0
    @bags = {}
    def bags
      @bags
    end

    def all_contents(bag)
      bags[bag]&.map do |count,subbag|
        (subbag ? [subbag] + all_contents(subbag) : [])
      end&.flatten&.uniq || []
    end

    def contents_count(bag)
      bags[bag]&.map do |count,subbag|
        (subbag ? count + (count*contents_count(subbag)) : 0)
      end&.sum || 0
    end

    File.foreach("data/p07.txt") do |line|
      bag, contents = *line.split(" contain ")
      bags[bag.gsub(/ bags?/,'')] = contents.gsub(/\.$/,'').split(",").map do |subbag|
        count, subbag = subbag.scan(/(\d+) (.+) bags?/).first
        [count.to_i, subbag]
      end
    end

    # matches = 0
    # bags.keys.each do |bag|
    #   contents = all_contents(bag)
    #   puts "checking #{bag} with contains: #{contents}"
    #   matches += 1 if contents.include?("shiny gold")
    # end
    # # counts = groups.map{|g| g.chars.uniq.size }
    # puts "found #{matches}"

    puts "shiny gold as #{contents_count("shiny gold")}"
  end
end