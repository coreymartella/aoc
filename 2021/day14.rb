class Day14 < Day
  def part1
    # debug!
    byebug
    poly,rules = *input.split("\n\n")
    replacements = rules.split("\n").map{|r| r.split(" -> ")}.to_h

    1.upto(10) do |step|
      puts! "step=#{step} poly_size=#{poly.size} poly=#{poly}"
      new_poly_chars = []
      poly_chars = poly.chars
      poly_chars.each_with_index do |c,i|
        key = "#{c}#{poly_chars[i+1]}"
        new_poly_chars << c
        if replacements[key]
          new_poly_chars << replacements[key]
        end
      end
      poly = new_poly_chars.join
    end
    histo = poly.chars.histogram
    puts "histo #{histo}"
    histo.values.max - histo.values.min
  end

  def part2
    # debug!
    replacements = {}
    poly = nil
    each_line do |line, linenum|
      if linenum == 0
        poly = line
      elsif line.present?
        replacements[line.split("->").first.strip] = line.split("->").last.strip
      end
    end
    poly_chars = poly.chars

    pairs = Hash.new(0)
    poly_chars.each_with_index do |c,i|
      if poly_chars[i+1]
        key = "#{c}#{poly_chars[i+1]}"
        pairs[key] += 1
      end
    end
    puts "pairs=#{pairs}"
    1.upto(40) do |iter|
      # puts! "iter=#{iter} poly_size=#{histo.values.sum} missing_reps=#{replacements.keys - pairs.keys} histo=#{histo}"
      new_pairs = Hash.new(0)
      pairs.keys.each do |p|
        rep = replacements[p]
        if rep
          new_pairs["#{p.chars.first}#{rep}"] += pairs[p]
          new_pairs["#{rep}#{p.chars.last}"] += pairs[p]
        else
          new_pairs[p] += pairs[p]
        end
      end
      pairs = new_pairs
    end
    histo = Hash.new(0)
    pairs.keys.each do |p|
      histo[p.first] += pairs[p]
    end
    histo[poly.last] += 1
    puts "histo #{histo}"
    histo.values.max - histo.values.min
  end
end
=begin
## --- Day 14: Extended Polymerization ---The incredible pressures at this depth are starting to put a strain on your submarine. The submarine has [polymerization](https://en.wikipedia.org/wiki/Polymerization "") equipment that would produce suitable materials to reinforce the submarine, and the nearby volcanically-active caves should even have the necessary input elements in sufficient quantities.

The submarine manual contains instructions for finding the optimal polymer formula; specifically, it offers a *polymer template* and a list of *pair insertion* rules (your puzzle input). You just need to work out what polymer would result after repeating the pair insertion process a few times.

For example:

```
NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C
```

The first line is the *polymer template* - this is the starting point of the process.

The following section defines the *pair insertion* rules. A rule like `AB -&gt; C` means that when elements `A` and `B` are immediately adjacent, element `C` should be inserted between them. These insertions all happen simultaneously.

So, starting with the polymer template `NNCB`, the first step simultaneously considers all three pairs:

* The first pair (`NN`) matches the rule `NN -&gt; C`, so element `*C*` is inserted between the first `N` and the second `N`.
* The second pair (`NC`) matches the rule `NC -&gt; B`, so element `*B*` is inserted between the `N` and the `C`.
* The third pair (`CB`) matches the rule `CB -&gt; H`, so element `*H*` is inserted between the `C` and the `B`.

Note that these pairs overlap: the second element of one pair is the first element of the next pair. Also, because all pairs are considered simultaneously, inserted elements are not considered to be part of a pair until the next step.

After the first step of this process, the polymer becomes `N*C*N*B*C*H*B`.

Here are the results of a few steps using the above rules:

```
Template:     NNCB
After step 1: NCNBCHB
After step 2: NBCCNBBBCBHCB
After step 3: NBBBCNCCNBBNBNBBCHBHHBCHB
After step 4: NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB
```

This polymer grows quickly. After step 5, it has length 97; After step 10, it has length 3073. After step 10, `B` occurs 1749 times, `C` occurs 298 times, `H` occurs 191 times, and `N` occurs 865 times; taking the quantity of the most common element (`B`, 1749) and subtracting the quantity of the least common element (`H`, 161) produces `1749 - 161 = *1588*`.

Apply 10 steps of pair insertion to the polymer template and find the most and least common elements in the result. *What do you get if you take the quantity of the most common element and subtract the quantity of the least common element?*
=end
