require 'spec_helper'

RSpec.describe Year2021::Day18 do
  let(:day) { described_class.new }
  let(:node_class) { described_class::Node }

  it 'parses and serializes lines' do
    %w([1,2]
        [[1,2],3]
        [9,[8,7]]
        [[1,9],[8,5]]
        [[[[1,2],[3,4]],[[5,6],[7,8]]],9]
        [[[9,[3,8]],[[0,9],6]],[[[3,7],[4,9]],3]]
        [[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]]).each do |line|
      expect(node_class.parse(line.strip).to_s).to eq(line)
    end
  end

  it 'adds' do
    n1 = node_class.new(l: 1, r: 2)
    n2 = node_class.new(l: 3, r: 4)

    expect((n1+n2).to_s).to eq("[#{n1.to_s},#{n2.to_s}]")
  end

  it 'mag' do
    n = node_class.parse("[[1,2],[[3,4],5]]")
    expect(n.mag).to eq(143)
    n = node_class.parse("[[[[5,0],[7,4]],[5,5]],[6,6]]")
    expect(n.mag).to eq(1137)
    n = node_class.parse("[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]")
    expect(n.mag).to eq(3488)
    n = node_class.parse("[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]")
    expect(n.mag).to eq(4140)
  end

  it 'explodes' do
    n = node_class.parse("[[[[[9,8],1],2],3],4]")
    n.reduce
    expect(n.to_s).to eq("[[[[0,9],2],3],4]")
  end

  it 'explodes left to right' do
    n = node_class.parse("[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]")
    n.reduce
    expect(n.to_s).to eq("[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]")
  end

  it 'does everything p1' do
    n1 = node_class.parse("[[[[4,3],4],4],[7,[[8,4],9]]]")
    n2 = node_class.parse("[1,1]")
    sum = n1 + n2
    sum.reduce!
    expect(sum.to_s).to eq("[[[[0,7],4],[[7,8],[6,0]]],[8,1]]")
  end

  it 'does everything' do
    n1 = node_class.parse("[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]")
    n2 = node_class.parse("[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]")
    sum = n1 + n2
    sum.reduce!
    expect(sum.to_s).to eq("[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]")
  end

  it "handles complex explode" do
    n = node_class.parse("[[[[4,0],[9,0]],[[7,7],[6,0]]],[[[6,6],[5,0]],[[0,[5,6]],[[6,6],[8,8]]]]]")
    n.reduce
    expect(n.to_s).to eq("[[[[4,0],[9,0]],[[7,7],[6,0]]],[[[6,6],[5,0]],[[5,0],[[12,6],[8,8]]]]]")

    # n = node_class.parse("[[[[4,0],[9,0]],[[7,7],[6,0]]],[[[6,6],[5,0]],[[0,[5,6]],[[6,6],[8,8]]]]]".reverse)
    # n.reduce
    # expect(n.to_s).to eq("[[[[4,0],[9,0]],[[7,7],[6,0]]],[[[6,6],[5,0]],[[5,0],[[12,6],[8,8]]]]]".reverse)
  end

  it "handles the larger example" do
    n1 = node_class.parse("[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]")
    n2 = node_class.parse("[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]")
    res = (n1+n2)
    res.reduce!
    expect(res.to_s).to eq("[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]")
  end

  it "handles [[[[4,3],4],4],[7,[[8,4],9]]] + [1,1] = [[[[0,7],4],[[7,8],[6,0]]],[8,1]]" do
    n1 = node_class.parse("[[[[4,3],4],4],[7,[[8,4],9]]]")
    n2 = node_class.parse("[1,1]")
    res = (n1+n2)
    res.reduce!
    expect(res.to_s).to eq("[[[[0,7],4],[[7,8],[6,0]]],[8,1]]")
  end

  it "handles final example" do
    lines = %w([[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
[[[5,[2,8]],4],[5,[[9,9],0]]]
[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
[[[[5,4],[7,7]],8],[[8,3],8]]
[[9,3],[[9,9],[6,[4,9]]]]
[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]])
    base = nil
    lines.each do |l|
      n = node_class.parse(l.strip)
      if base
        base = base + n
        base.reduce!
      else
        base = n
      end
    end
    expect(base.to_s).to eq("[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]")
    expect(base.mag).to eq(4140)
  end

  def node(val)
    node_class.parse(val.to_s)
  end

  it "handles reddit sequence" do
    n = node([[[[[7,0],[7,7]],[[7,7],[7,8]]],[[[7,7],[8,8]],[[7,7],[8,7]]]],[7,[5,[[3,8],[1,4]]]]])
    expect(n).to be_root
    n.reduce!
    expect(n.to_s).to eq("[[[[[7,7],[7,8]],[[9,5],[8,7]]],[[[6,8],[0,8]],[[9,9],[9,0]]]],[[2,[2,2]],[8,[8,1]]]]")
  end

  it "handles the granular final example" do
    n = node([[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]])
    n = n + node([7,[[[3,7],[4,3]],[[6,3],[8,8]]]])
    n.reduce!
    expect(n.to_s).to eq("[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]")

    n = node([[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]])
    n = n + node([[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]])
    n.reduce!
    expect(n.to_s).to eq("[[[[6,7],[6,7]],[[7,7],[0,7]]],[[[8,7],[7,7]],[[8,8],[8,0]]]]")

    n = node([[[[6,7],[6,7]],[[7,7],[0,7]]],[[[8,7],[7,7]],[[8,8],[8,0]]]])
    n = n+ node([[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]])
    n.reduce!
    expect(n.to_s).to eq("[[[[7,0],[7,7]],[[7,7],[7,8]]],[[[7,7],[8,8]],[[7,7],[8,7]]]]")


    n = node([[[[7,0],[7,7]],[[7,7],[7,8]]],[[[7,7],[8,8]],[[7,7],[8,7]]]])
    n = n + node([7,[5,[[3,8],[1,4]]]])
    n.reduce!
    expect(n.to_s).to eq("[[[[7,7],[7,8]],[[9,5],[8,7]]],[[[6,8],[0,8]],[[9,9],[9,0]]]]")

    n = node([[[[7,7],[7,8]],[[9,5],[8,7]]],[[[6,8],[0,8]],[[9,9],[9,0]]]])
    n = n + node([[2,[2,2]],[8,[8,1]]])
    n.reduce!
    expect(n.to_s).to eq("[[[[6,6],[6,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]]")

    n = node([[[[6,6],[6,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]])
    n = n + node([2,9])
    n.reduce!
    expect(n.to_s).to eq("[[[[6,6],[7,7]],[[0,7],[7,7]]],[[[5,5],[5,6]],9]]")

    n = node([[[[6,6],[7,7]],[[0,7],[7,7]]],[[[5,5],[5,6]],9]])
    n = n + node([1,[[[9,3],9],[[9,0],[0,7]]]])
    n.reduce!
    expect(n.to_s).to eq("[[[[7,8],[6,7]],[[6,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]]")

    n = node([[[[7,8],[6,7]],[[6,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]])
    n = n + node([[[5,[7,4]],7],1])
    n.reduce!
    expect(n.to_s).to eq("[[[[7,7],[7,7]],[[8,7],[8,7]]],[[[7,0],[7,7]],9]]")

      [[[[7,7],[7,7]],[[8,7],[8,7]]],[[[7,0],[7,7]],9]]
    + [[[[4,2],2],6],[8,7]]
    n.reduce!
    expect(n.to_s).to eq("[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]")
  end

  it "handles part2 example" do
    lines = %w([[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
    [[[5,[2,8]],4],[5,[[9,9],0]]]
    [6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
    [[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
    [[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
    [[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
    [[[[5,4],[7,7]],8],[[8,3],8]]
    [[9,3],[[9,9],[6,[4,9]]]]
    [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
    [[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]])
    curr = nil
    max_mag = 0
    max_mag_node = nil
    lines.each_with_index do |line,i|
      lines[i+1..-1].each do |line2|
        n1 = node(line)
        n2 = node(line2)
        curr_comp = n1+n2
        curr_comp.reduce!
        if curr_comp.mag > max_mag
          puts "updating max_mag=#{max_mag} to #{curr_comp.mag} #{line2} + #{line} which reduces to #{curr_comp.to_s}"
          max_mag = curr_comp.mag
          max_mag_node = curr_comp.to_s
        end
        n1 = node(line)
        n2 = node(line2)
        curr_comp = n2+n1
        curr_comp.reduce!
        if curr_comp.mag > max_mag
          puts "updating max_mag=#{max_mag} to #{curr_comp.mag} #{line2} + #{line} which reduces to #{curr_comp.to_s}"
          max_mag = curr_comp.mag
          max_mag_node = curr_comp.to_s
        end
        puts "#{lines[i-1]}+#{line} = #{curr.to_s} mag=#{curr_comp.mag}"
      end

      n = node(line)
      if !curr
        curr = n
      else
        curr = curr + n
        curr.reduce!
      end
    end
    # The largest magnitude of the sum of any two snailfish numbers in this list is 3993. This is the magnitude of [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]] + [[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]], which reduces to [[[[7,8],[6,6]],[[6,0],[7,7]]],[[[7,8],[8,8]],[[7,9],[0,6]]]]
    expect(max_mag).to eq(3993)
    expect(max_mag_node).to eq("[[[[7,8],[6,6]],[[6,0],[7,7]]],[[[7,8],[8,8]],[[7,9],[0,6]]]]")
  end
end