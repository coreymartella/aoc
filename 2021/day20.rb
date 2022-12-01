class Day20 < Day
  # data is [], graph is {k => []}, f is {k => 0}, h is {}, result,r,c,x,y are ints
  attr_accessor :image, :enhancement
  def part1
    # debug!
    @enhancement,@image = *input.split("\n\n").map(&:strip)
    @enhancement = enhancement.chars.map{|c| c == '#' ? 1 : 0}
    raise "invalid enc data" unless @enhancement.size == 512

    @image = @image.strip.lines.map{|l| l.strip.chars.map{|c| c == '#' ? 1 : 0}}
    raise "invalid image data #{image.size}x#{image.first.size}" unless @image.size == @image.first.size

    puts "START IMAGE"
    puts image.map{|l| l.map{|v| v == 1 ? "#" : '.'}.join}.join("\n")
    puts
    # hack we know this to be 1 and 0 respectively
    all_off_pixel = @enhancement[0]
    all_on_pixel = @enhancement[511]
    default_state = 0

    1.upto(50) do |iter|
      image_out = []
      w = image.first.size
      h = image.size
      image.each_with_index do |l,row|
        new_row = row + 1
        image_out[new_row] = []
        image_out[0] = [] if row == 0
        image_out[row+2] = [] if row == image.size-1

        l.each_with_index do |v, col|
          new_col = col + 1
          if row == 0
            # need to fill in the new row above
            if col == 0 #need to fill in the new TL corner
              image_out[0][0] = new_state(-1,-1, default_state)
            end
            image_out[0][new_col] = new_state(-1,col, default_state)
          end

          if col == 0 #need to fill the new column to the left
            image_out[new_row][new_col-1] = new_state(row,col-1, default_state)
          end

          image_out[new_row][new_col] = new_state(row,col, default_state)

          if col == w - 1 # fill in column to right
            if row == 0 # new to fill in new TR
              image_out[0][new_col+1] = new_state(-1,w, default_state)
            end
            image_out[new_row][new_col+1] = new_state(row,w, default_state)
          end

          if row == h-1
            # need to fill in the new row below
            if col == 0 #need to fill in the new BL corner
              image_out[new_row+1][0] = new_state(h,-1, default_state)
            end
            image_out[new_row+1][new_col] = new_state(h,col, default_state)
            if col == w-1 #need to fill in the new BR corner
              image_out[new_row+1][new_col+1] = new_state(h,w, default_state)
            end
          end

        end
        if row == 0 && image_out[0].size != w+2
          raise "image_out[0] is #{image_out[0].size} expected #{w}"
        elsif image_out[new_row].size != w+2
          raise "image_out[#{new_row}] is #{image_out[new_row].size} expected #{w}"
        elsif row == h-1 && image_out[new_row+1].size != w+2
          raise "image_out[#{new_row+1}] is #{image_out[new_row+1].size} expected #{w}"
        end
      end
      raise "new_image isn't #{w+2}x#{h+2} its #{image_out.size}x#{image_out.map(&:size).uniq.sort}" unless image_out.size == h + 2 && image_out.all?{|r| r.size == w+2}
      # puts "\nafter #{iter} old #{w}x#{h}: #{@image.sum(&:sum)} new #{image_out.size}x#{image_out.first.size} #{image_out.sum(&:sum)}"
      # puts image_out.map{|l| l.map{|v| v == 1 ? "#" : '.'}.join}.join("\n")
      # puts
      #flip the default state
      default_state = (default_state-1).abs
      @image = image_out

    end
    result = @image.sum(&:sum)
    puts "P1=#{result}"

    # # debug!
    # #
    # # v1, v2 = *input.split("\n\n")
    # each_line do |line, li|
    #   # v1,v2 = *line.scan[/.../].flatten
    # end

    # # max_iters = 10
    # # 1.upto(max_iters) do |iter|
    # #
    # # end
    # 5556 too high using , 5699 too high 5575 too high
    result
  end

  def new_state(row,col,default_state)
    h = @image.size
    w = @image.first.size
    # print "\r#{row},#{col} in #{h}x#{w}"
    # if row == 2 && col == 2
    #   byebug
    # end
    index = 0
    if row > 0
      if col > 0
        index += 256*@image[row-1][col-1]
      else
        index += 256*default_state
      end
      if col >= 0 && col < w
        index += 128*@image[row-1][col]
      else
        index += 128*default_state
      end
      if col < w-1
        index += 64*@image[row-1][col+1]
      else
        index += 64*default_state
      end
    else
      index += 256*default_state
      index += 128*default_state
      index += 64*default_state
    end

    if row >= 0 && row < h
      if col > 0
        index += 32*@image[row][col-1]
      else
        index += 32*default_state
      end
      if col >= 0 && col < w
        index += 16*@image[row][col]
      else
        index += 16*default_state
      end

      if col < w-1
        index += 8*@image[row][col+1]
      else
        index += 8*default_state
      end
    else
      index += 32*default_state
      index += 16*default_state
      index += 8*default_state
    end

    if row < h-1
      if col > 0
        index += 4*@image[row+1][col-1]
      else
        index += 4*default_state
      end
      if col >= 0 && col < w
        index += 2*@image[row+1][col]
      else
        index += 2*default_state
      end
      if col < w-1
        index += 1*@image[row+1][col+1]
      else
        index += 1*default_state
      end
    else
      index += 4*default_state
      index += 2*default_state
      index += 1*default_state
    end
    # puts " -> #{index} -> #{@enhancement[index]}"
    @enhancement[index]
  end
  # def part2
  #   # debug!
  # end
end
=begin

=end
