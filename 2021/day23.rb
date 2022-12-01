#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'day'
class Day23 < Day
  INFINITY = MAX_COST = 1 << 32
  GOAL = "...........ABCDABCDABCDABCD"
  attr_accessor :seen, :gs, :fs, :opens
  def part1
    @seen = {}
    @iters = 0
    state = compress(input)

    # The set of discovered nodes that may need to be (re-)expanded.
    # Initially, only the start node is known.
    # This is usually implemented as a min-heap or priority queue rather than a hash-set.

    # For node n, cameFrom[n] is the node immediately preceding it on the cheapest path from start
    # to n currently known.
    came_from = {}

    # For node n, gScore[n] is the cost of the cheapest path from start to n currently known.
    @gs= Hash.new(INFINITY)
    @gs[state] = 0

    # For node n, fScore[n] := gScore[n] + h(n). fScore[n] represents our current best guess as to
     # how short a path from start to finish can be if it goes through n.
    @fs= Hash.new(INFINITY)
    @fs[state] = h(state)
    # @opens = Heap.new{|a, b| a.last < b.last}
    @opens = FastContainers::PriorityQueue.new(:min)
    opens.push(state,fs[state])
    # 39665 too low
    while opens.any?
      current = opens.pop
      printf("\ropens=%5d seen=%6d", opens.size, came_from.size)
      if debug_states[current]
        # byebug
        debug_states[current] += 1
      end
      if current == GOAL
        path = []
        prev = current
        while came_from[prev]
          path << prev
          prev = came_from[prev]
        end
        prev_gs = 0
        path.reverse.each do |state|
          puts "TOTAL=#{gs[state]} COST=#{gs[state]-prev_gs}"
          prev_gs = gs[state]
          display(state)
          puts "  #########"
        end

        debug_states.each{|s,t| puts "SEEN #{t} times:\n#{decompress(s)}\n\n"}
        puts "\n\nfound #{gs[current]}"
        # return reconstruct_path(cameFrom, current)
        return
      end
      ns = neighbours(current)
      ns.each do |neighbour,cost|
        # // d(current,neighbour) is the weight of the edge from current to neighbor
        # // tentative_gScore is the distance from start to the neighbor through current
        gs_tent = gs[current] + cost
        if gs_tent < gs[neighbour]
          # This path to neighbour is better than any previous one. Record it!
          came_from[neighbour] = current
          gs[neighbour] = gs_tent
          fs[neighbour] = gs_tent + h(neighbour)
          opens.push(neighbour,fs[neighbour])
        end
      end
    end
    puts "\n\n NO ROUTE FOUND!!!!\n\n"
    # // Open set is empty but goal was never reached
    return INFINITY
  end

  def compress(state)
    state.gsub(/\s/,'').gsub('#','').strip
  end
  def decompress(state)
    state = compress(state)
    ds = +"#############\n##{state[0..10]}#\n"
    1.upto(4) do |pos|
      data = (1..4).map{|r| state[self.class.const_get("R#{r}#{pos}")]}.join("#")
      ds << "#{pos == 1 ? '##' : '  '}##{data}##{pos == 1 ? '##' : '  '}\n"
    end
    ds << "  #########  "
    ds
  end
  def display(state)
    puts decompress(state)
  end

  def neighbours(state)
    # byebug

    res = []

    r1 = room1(state)
    r2 = room2(state)
    r3 = room3(state)
    r4 = room4(state)
    lh = lhall(state)
    rh = rhall(state)
    h12 = hall12(state)
    h23 = hall23(state)
    h34 = hall34(state)
    lhe2 = (lh == E2)
    rhe2 = (rh == E2)
    lhe1 = (lh[1] == E)
    rhe1 = (rh[0] == E)
    h12e = h12 == E
    h23e = h23 == E
    h34e = h34 == E


    # possible moves

    src = dest = mover = moves = nil
    ## TRY ROOM 1
    if r1 !~ /[\.A]{4}/
      # can take something out of room 1
      r1.chars.each_with_index do |c,i|
        next unless c != E
        mover = c
        src = self.class.const_get("R1#{i+1}")
        moves = i+1
        break
      end

      if lhe2
        #can move from room1 to far end lhall
        new_state = swap(state,src,LHALL.first)
        new_moves = moves + 2
        res << [new_state,new_moves*COST[mover]]
      end

      if lhe1
        #can move from room1 to close end lhall
        new_state = swap(state,src,LHALL.last)
        new_moves = moves + 1
        res << [new_state,new_moves*COST[mover]]
      end

      if h12e
        #can move into the hallway between 1 and 2
        new_state = swap(state,src,H12)
        new_moves = moves + 1
        res << [new_state,new_moves*COST[mover]]
      end

      if h12e && h23e
        # puts "#{"  "* level} removing from room1 into h23"
        #can move into the hallway between 2 and 3
        new_state = swap(state,src,H23)
        new_moves = moves + 3
        res << [new_state,new_moves*COST[mover]]
      end
      if h12e && h23e && h34e
        # puts "#{"  "* level} removing from room1 into h23"
        #can move into the hallway between 34
        new_state = swap(state,src,H34)
        new_moves = moves + 5
        res << [new_state,new_moves*COST[mover]]
      end

      if h12e && h23e && h34e && rhe1
        #can move to close end of RHALL
        new_state = swap(state,src,RHALL.first)
        new_moves = moves + 7
        res << [new_state,new_moves*COST[mover]]
      end
      if h12e && h23e && h34e && rhe2
        #can move to far end of RHALL
        new_state = swap(state,src,RHALL.last)
        new_moves = moves + 8
        res << [new_state,new_moves*COST[mover]]
      end
    end
    ## TRY ROOM 1

    ## TRY ROOM 2
    if r2 !~ /[\.B]{4}/
      # can take something out of room 1
      r2.chars.each_with_index do |c,i|
        next unless c != E
        mover = c
        src = self.class.const_get("R2#{i+1}")
        moves = i+1
        break
      end

      if h12e && lhe2
        #can move to far end lhall
        new_state = swap(state,src,LHALL.first)
        new_moves = moves + 4
        res << [new_state,new_moves*COST[mover]]
      end

      if h12e && lhe1
        #can move to close end lhall
        new_state = swap(state,src,LHALL.last)
        new_moves = moves + 3
        res << [new_state,new_moves*COST[mover]]
      end

      if h12e
        #can move into the hallway between 1 and 2
        new_state = swap(state,src,H12)
        new_moves = moves + 1
        res << [new_state,new_moves*COST[mover]]
      end

      if h23e
        #can move into the hallway between 2 and 3
        new_state = swap(state,src,H23)
        new_moves = moves + 1
        res << [new_state,new_moves*COST[mover]]
      end

      if h23e && h34e
        #can move into the hallway between 34
        new_state = swap(state,src,H34)
        new_moves = moves + 3
        res << [new_state,new_moves*COST[mover]]
      end

      if h12e && h23e && h34e && rhe1
        #can move to close end of RHALL
        new_state = swap(state,src,RHALL.first)
        new_moves = moves + 5
        res << [new_state,new_moves*COST[mover]]
      end
      if h23e && h34e && rhe2
        #can move to far end of RHALL
        new_state = swap(state,src,RHALL.last)
        new_moves = moves + 6
        res << [new_state,new_moves*COST[mover]]
      end
    end

    ## TRY ROOM 3
    if r3 !~ /[\.C]{4}/
      # can take something out of room 1
      r3.chars.each_with_index do |c,i|
        next unless c != E
        mover = c
        src = self.class.const_get("R3#{i+1}")
        moves = i+1
        break
      end

      if h23e && h12e && lhe2
        #can move to far end lhall
        new_state = swap(state,src,LHALL.first)
        new_moves = moves + 6
        res << [new_state,new_moves*COST[mover]]
      end
      if h23e && h12e && lhe1
        #can move to close end lhall
        new_state = swap(state,src,LHALL.last)
        new_moves = moves + 5
        res << [new_state,new_moves*COST[mover]]
      end

      if h23e && h12e
        #can move into the hallway between 1 and 2
        new_state = swap(state,src,H12)
        new_moves = moves + 3
        res << [new_state,new_moves*COST[mover]]
      end

      if h23e
        #can move into the hallway between 2 and 3
        new_state = swap(state,src,H23)
        new_moves = moves + 1
        res << [new_state,new_moves*COST[mover]]
      end

      if h34e
        #can move into the hallway between 34
        new_state = swap(state,src,H34)
        new_moves = moves + 1
        res << [new_state,new_moves*COST[mover]]
      end

      if h34e && rhe1
        #can move to close end of RHALL
        new_state = swap(state,src,RHALL.first)
        new_moves = moves + 3
        res << [new_state,new_moves*COST[mover]]
      end
      if h34e && rhe2
        #can move to far end of RHALL
        new_state = swap(state,src,RHALL.last)
        new_moves = moves + 4
        res << [new_state,new_moves*COST[mover]]
      end
    end


    if r4 !~ /[\.D]{4}/
      # can take something out of room 1
      r4.chars.each_with_index do |c,i|
        next unless c != E
        mover = c
        src = self.class.const_get("R4#{i+1}")
        moves = i+1
        break
      end

      if h34e && h23e && h12e && lhe2
        #can move to far end lhall
        new_state = swap(state,src,LHALL.first)
        new_moves = moves + 8
        res << [new_state,new_moves*COST[mover]]
      end
      if h34e && h23e && h12e && lhe1
        #can move to close end lhall
        new_state = swap(state,src,LHALL.last)
        new_moves = moves + 7
        res << [new_state,new_moves*COST[mover]]
      end

      if h34e && h23e && h12e
        #can move into the hallway between 1 and 2
        new_state = swap(state,src,H12)
        new_moves = moves + 5
        res << [new_state,new_moves*COST[mover]]
      end

      if h34e && h23e
        #can move into the hallway between 2 and 3
        new_state = swap(state,src,H23)
        new_moves = moves + 3
        res << [new_state,new_moves*COST[mover]]
      end

      if h34e
        #can move into the hallway between 34
        new_state = swap(state,src,H34)
        new_moves = moves + 1
        res << [new_state,new_moves*COST[mover]]
      end

      if rhe2
        #can move to far end of RHALL
        new_state = swap(state,src,RHALL.last)
        new_moves = moves + 2
        res << [new_state,new_moves*COST[mover]]
      end
      if rhe1
        #can move to close end of RHALL
        new_state = swap(state,src,RHALL.first)
        new_moves = moves + 1
        res << [new_state,new_moves*COST[mover]]
      end
    end

    if r1 =~ /\.[\.A]{3}/
      #put something into room 1
      # can take something out of room 1
      3.downto(0) do |i|
        next if r1[i] != E
        mover = c
        dest = self.class.const_get("R1#{i+1}")
        moves = i+1
        break
      end

      t = 'A'
      if lh[1] == t
        new_state = swap(state,LHALL.last,dest)
        new_moves = moves + 1
        mover = lh[1]
        res << [new_state,new_moves*COST[mover]]
      elsif lh[0] == t && lhe1
        new_state = swap(state,LHALL.first,dest)
        new_moves = moves + 2
        mover = lh[0]
        res << [new_state,new_moves*COST[mover]]
      end

      if h12 == t
        new_state = swap(state,H12,dest)
        new_moves = moves + 1
        mover = h12
        res << [new_state,new_moves*COST[mover]]
      end

      if h12e && h23 == t
        new_state = swap(state,H23,dest)
        new_moves = moves + 3
        mover = h23
        res << [new_state,new_moves*COST[mover]]
      end

      if h12e && h23e && h34 == t
        new_state = swap(state,H34,dest)
        new_moves = moves + 5
        mover = h34
        res << [new_state,new_moves*COST[mover]]
      end

      if h12e && h23e && h34e && rh[0] == t
        new_state = swap(state,RHALL.first,dest)
        new_moves = moves + 7
        mover = rh[0]
        res << [new_state,new_moves*COST[mover]]
      elsif h12e && h23e && h34e && rhe1 && rh[1] == t
        new_state = swap(state,RHALL.last,dest)
        new_moves = moves + 8
        mover = rh[1]
        res << [new_state,new_moves*COST[mover]]
      end
    end

    if r2 =~ /\.[\.B]{3}/
      #put something into room 1
      # can take something out of room 1
      3.downto(0) do |i|
        next if r2[i] != E
        mover = c
        dest = self.class.const_get("R2#{i+1}")
        moves = i+1
        break
      end

      t = 'B'
      if h12e && lh[1] == t
        new_state = swap(state,LHALL.last,dest)
        new_moves = moves + 3
        mover = lh[1]
        res << [new_state,new_moves*COST[mover]]
      elsif h12e && lhe1 && lh[0] == t
        new_state = swap(state,LHALL.first,dest)
        new_moves = moves + 4
        mover = lh[0]
        res << [new_state,new_moves*COST[mover]]
      end

      if h12 == t
        new_state = swap(state,H12,dest)
        new_moves = moves + 1
        mover = h12
        res << [new_state,new_moves*COST[mover]]
      end

      if h23 == t
        new_state = swap(state,H23,dest)
        new_moves = moves + 1
        mover = h23
        res << [new_state,new_moves*COST[mover]]
      end

      if h23e && h34 == t
        new_state = swap(state,H34,dest)
        new_moves = moves + 3
        mover = h34
        res << [new_state,new_moves*COST[mover]]
      end

      if h23e && h34e && rh[0] == t
        new_state = swap(state,RHALL.first,dest)
        new_moves = moves + 5
        mover = rh[0]
        res << [new_state,new_moves*COST[mover]]
      elsif h23e && h34e && rhe1 && rh[1] == t
        new_state = swap(state,RHALL.last,dest)
        new_moves = moves + 6
        mover = rh[1]
        res << [new_state,new_moves*COST[mover]]
      end
    end

    #put something into room 3
    if r3 =~ /\.[\.C]{3}/
      3.downto(0) do |i|
        next if r3[i] != E
        dest = self.class.const_get("R3#{i+1}")
        moves = i+1
        break
      end

      t = 'C'
      if h23e && h12e && lh[1] == t
        new_state = swap(state,LHALL.last,dest)
        new_moves = moves + 5
        mover = lh[1]
        res << [new_state,new_moves*COST[mover]]
      elsif h23e && h12e && lhe1 && lh[0] == t
        new_state = swap(state,LHALL.first,dest)
        new_moves = moves + 6
        mover = lh[0]
        res << [new_state,new_moves*COST[mover]]
      end

      if h23e && h12 == t
        new_state = swap(state,H12,dest)
        new_moves = moves + 3
        mover = h12
        res << [new_state,new_moves*COST[mover]]
      end

      if h23 == t
        new_state = swap(state,H23,dest)
        new_moves = moves + 1
        mover = h23
        res << [new_state,new_moves*COST[mover]]
      end

      if h34 == t
        new_state = swap(state,H34,dest)
        new_moves = moves + 1
        mover = h34
        res << [new_state,new_moves*COST[mover]]
      end

      if h34e && rh[0] == t
        new_state = swap(state,RHALL.first,dest)
        new_moves = moves + 3
        mover = rh[0]
        res << [new_state,new_moves*COST[mover]]
      elsif h34e && rhe1 && rh[1] == t
        new_state = swap(state,RHALL.last,dest)
        new_moves = moves + 4
        mover = rh[1]
        res << [new_state,new_moves*COST[mover]]
      end
    end

    #put something into room 4
    if r4 =~ /\.[\.D]{3}/
      3.downto(0) do |i|
        next if r4[i] != E
        dest = self.class.const_get("R4#{i+1}")
        moves = i+1
        break
      end

      t = 'D'
      if h34e && h23e && h12e && lh[1] == t
        new_state = swap(state,LHALL.last,dest)
        new_moves = moves + 7
        mover = lh[1]
        res << [new_state,new_moves*COST[mover]]
      elsif h34e && h23e && h12e && lhe1 && lh[0] == t
        new_state = swap(state,LHALL.first,dest)
        new_moves = moves + 8
        mover = lh[0]
        res << [new_state,new_moves*COST[mover]]
      end

      if h34e && h23e && h12 == t
        new_state = swap(state,H12,dest)
        new_moves = moves + 5
        mover = h12
        res << [new_state,new_moves*COST[mover]]
      end

      if h34e && h23 == t
        new_state = swap(state,H23,dest)
        new_moves = moves + 3
        mover = h23
        res << [new_state,new_moves*COST[mover]]
      end

      if h34 == t
        new_state = swap(state,H34,dest)
        new_moves = moves + 1
        mover = h34
        res << [new_state,new_moves*COST[mover]]
      end

      if rh[0] == t
        new_state = swap(state,RHALL.first,dest)
        new_moves = moves + 1
        mover = rh[0]
        res << [new_state,new_moves*COST[mover]]
      elsif rhe1 && rh[1] == t
        new_state = swap(state,RHALL.last,dest)
        new_moves = moves + 2
        mover = rh[1]
        res << [new_state,new_moves*COST[mover]]
      end
    end
    res
  end

  def swap(state,src,dst)
    mover = state[src]
    new_state = state.dup
    new_state[dst] = mover
    new_state[src] = E
    new_state
  end

  E = '.'
  E2 = '..'
  E3 = '...'
  E4 = '....'
  COST = {
    'A' => 1,
    'B' => 10,
    'C' => 100,
    'D' => 1000,
  }

  # state[0..12] #top wall
  # state[15..25] #hallway
  # state[28..39] #first layer of rooms
  # state[42..52] #second layer of rooms

  R10 = 2
  R11 = 11
  R12 = 15
  R13 = 19
  R14 = 23
  R1 = [R11,R12, R13, R14]
  def room1(state)
    (+"").concat(state[R11],state[R12],state[R13],state[R14])
  end

  R20 = 4
  R21 = 12
  R22 = 16
  R23 = 20
  R24 = 24
  R2 = [R21,R22, R23, R24]
  def room2(state)
    (+"").concat(state[R21],state[R22],state[R23],state[R24])
  end

  R30 = 6
  R31 = 13
  R32 = 17
  R33 = 21
  R34 = 25
  R3 = [R31,R32, R33, R34]
  def room3(state)
    (+"").concat(state[R31],state[R32],state[R33],state[R34])
  end

  R40 = 8
  R41 = 14
  R42 = 18
  R43 = 22
  R44 = 26
  R4 = [R41,R42, R43, R44]
  def room4(state)
    (+"").concat(state[R41],state[R42],state[R43],state[R44])
  end

  LHALL = 0..1
  def lhall(state)
    state[LHALL]
  end

  H12 = 3
  def hall12(state)
    state[H12]
  end

  H23 = 5
  def hall23(state)
    state[H23]
  end

  H34 = 7
  def hall34(state)
    state[H34]
  end

  RHALL = 9..10
  def rhall(state)
    state[RHALL]
  end

  def dist
    @dist ||= begin
      h = Hash.new#(INFINITY)

      1.upto(4) do |room|
        1.upto(4) do |spot|

          [LHALL.to_a, H12, H23, H34, RHALL.to_a].flatten.each do |hl|
            base = self.class.const_get("R#{room}0")
            rl = self.class.const_get("R#{room}#{spot}")
            hd = (hl - base).abs
            rd = spot
            h[[hl,rl]] = hd + rd
            h[[rl,hl]] = hd + rd
          end

          (room+1).upto(4) do |oroom|
            1.upto(4) do |ospot|
              rl = self.class.const_get("R#{room}#{spot}")
              orl = self.class.const_get("R#{oroom}#{ospot}")
              hd = (oroom-room).abs*2 # from room 1 to room 2 is 2 hallways spots
              rd = spot + ospot #dist from room to hallways then hallway to room
              h[[orl,rl]] = hd + rd
              h[[rl,orl]] = hd + rd
            end
          end
        end
      end
      h
    end
  end

  def h(state)
    i = -1
    cost = 0
    ['A','B','C','D'].each_with_index do |el,rn|
      dests = self.class.const_get("R#{rn+1}")
      i = -1
      all = []
      while i = state.index(el,i+1)
        all << i
      end
      # BAD, if one is in the right room but something under it needs out it will get cost 0
      used = dests & all
      dests -= used
      all -= used

      dests.reverse.each_with_index do |dest,i|
        dest_d = dist[[dest,all[i]]]
        if !dest_d
          binding.pry
        end
        cost += COST[el]*dest_d
      end
    end
    cost
  end

  # def debug_states
  #   @debug_states ||= {
  #     "#############\n#...........#\n###B#C#B#D###\n  #A#D#C#A#\n  #########"  => 0,
  #     # One Bronze amphipod moves into the hallway, taking 4 steps and using 40 energy:
  #     "#############\n#...B.......#\n###B#C#.#D###\n  #A#D#C#A#\n  #########"  => 0,
  #     # The only Copper amphipod not in its side room moves there, taking 4 steps and using 400 energy:
  #     "#############\n#...B.C.....#\n###B#.#.#D###\n  #A#D#C#A#\n  #########" => 0,
  #     "#############\n#...B.......#\n###B#.#C#D###\n  #A#D#C#A#\n  #########" => 0,
  #     #A Desert amphipod moves out of the way, taking 3 steps and using 3000 energy, and then the Bronze amphipod takes its place, taking 3 steps and using 30 energy:
  #     "#############\n#.....D.....#\n###B#.#C#D###\n  #A#B#C#A#\n  #########" => 0,
  #     "#############\n#...B.D.....#\n###B#.#C#D###\n  #A#.#C#A#\n  #########" => 0,
  #     #The leftmost Bronze amphipod moves to its room using 40 energy:
  #     "#############\n#...B.D.....#\n###.#.#C#D###\n  #A#B#C#A#\n  #########" => 0,
  #     "#############\n#.....D.....#\n###.#B#C#D###\n  #A#B#C#A#\n  #########" => 0,
  #     #Both amphipods in the rightmost room move into the hallway, using 2003 energy in total:
  #     "#############\n#.....D.D...#\n###.#B#C#.###\n  #A#B#C#A#\n  #########" => 0,
  #     "#############\n#.....D.D.A.#\n###.#B#C#.###\n  #A#B#C#.#\n  #########" => 0,
  #     # Both Desert amphipods move into the rightmost room using 7000 energy:
  #     "#############\n#.....D...A.#\n###.#B#C#.###\n  #A#B#C#D#\n  #########" => 0,
  #     "#############\n#.........A.#\n###.#B#C#D###\n  #A#B#C#D#\n  #########" => 0,
  #     #Finally, the last Amber amphipod moves into its room, using 8 energy:
  #     "#############\n#...........#\n###A#B#C#D###\n  #A#B#C#D#\n  #########" => 0,
  #   }
  # end
  def debug_states
    @debug_states ||= "#############
#...........#
###B#C#B#D###
  #D#C#B#A#
  #D#B#A#C#
  #A#D#C#A#
  #########

#############
#..........D#
###B#C#B#.###
  #D#C#B#A#
  #D#B#A#C#
  #A#D#C#A#
  #########

#############
#A.........D#
###B#C#B#.###
  #D#C#B#.#
  #D#B#A#C#
  #A#D#C#A#
  #########

#############
#A........BD#
###B#C#.#.###
  #D#C#B#.#
  #D#B#A#C#
  #A#D#C#A#
  #########

#############
#A......B.BD#
###B#C#.#.###
  #D#C#.#.#
  #D#B#A#C#
  #A#D#C#A#
  #########

#############
#AA.....B.BD#
###B#C#.#.###
  #D#C#.#.#
  #D#B#.#C#
  #A#D#C#A#
  #########

#############
#AA.....B.BD#
###B#.#.#.###
  #D#C#.#.#
  #D#B#C#C#
  #A#D#C#A#
  #########

#############
#AA.....B.BD#
###B#.#.#.###
  #D#.#C#.#
  #D#B#C#C#
  #A#D#C#A#
  #########

#############
#AA...B.B.BD#
###B#.#.#.###
  #D#.#C#.#
  #D#.#C#C#
  #A#D#C#A#
  #########

#############
#AA.D.B.B.BD#
###B#.#.#.###
  #D#.#C#.#
  #D#.#C#C#
  #A#.#C#A#
  #########

#############
#AA.D...B.BD#
###B#.#.#.###
  #D#.#C#.#
  #D#.#C#C#
  #A#B#C#A#
  #########

#############
#AA.D.....BD#
###B#.#.#.###
  #D#.#C#.#
  #D#B#C#C#
  #A#B#C#A#
  #########

#############
#AA.D......D#
###B#.#.#.###
  #D#B#C#.#
  #D#B#C#C#
  #A#B#C#A#
  #########

#############
#AA.D......D#
###B#.#C#.###
  #D#B#C#.#
  #D#B#C#.#
  #A#B#C#A#
  #########

#############
#AA.D.....AD#
###B#.#C#.###
  #D#B#C#.#
  #D#B#C#.#
  #A#B#C#.#
  #########

#############
#AA.......AD#
###B#.#C#.###
  #D#B#C#.#
  #D#B#C#.#
  #A#B#C#D#
  #########

#############
#AA.......AD#
###.#B#C#.###
  #D#B#C#.#
  #D#B#C#.#
  #A#B#C#D#
  #########

#############
#AA.......AD#
###.#B#C#.###
  #.#B#C#.#
  #D#B#C#D#
  #A#B#C#D#
  #########

#############
#AA.D.....AD#
###.#B#C#.###
  #.#B#C#.#
  #.#B#C#D#
  #A#B#C#D#
  #########

#############
#A..D.....AD#
###.#B#C#.###
  #.#B#C#.#
  #A#B#C#D#
  #A#B#C#D#
  #########

#############
#...D.....AD#
###.#B#C#.###
  #A#B#C#.#
  #A#B#C#D#
  #A#B#C#D#
  #########

#############
#.........AD#
###.#B#C#.###
  #A#B#C#D#
  #A#B#C#D#
  #A#B#C#D#
  #########

#############
#..........D#
###A#B#C#.###
  #A#B#C#D#
  #A#B#C#D#
  #A#B#C#D#
  #########

#############
#...........#
###A#B#C#D###
  #A#B#C#D#
  #A#B#C#D#
  #A#B#C#D#
  #########
".split("\n\n").each_with_object({}){|s,h| h[compress(s)] = 0}
  end
end

if __FILE__ == $0
  ENV["INPUT"] = ARGV.last || __FILE__.split("/").last.gsub(".rb",'')
  Day23.new.part1
end

=begin
## --- Day 23: Amphipod ---A group of [amphipods](https://en.wikipedia.org/wiki/Amphipoda "") notice your fancy submarine and flag you down. "With such an impressive shell," one amphipod says, "surely you can help us with a question that has stumped our best scientists."

They go on to explain that a group of timid, stubborn amphipods live in a nearby burrow. Four types of amphipods live there: *Amber* (`A`), *Bronze* (`B`), *Copper* (`C`), and *Desert* (`D`). They live in a burrow that consists of a *hallway* and four *side rooms*. The side rooms are initially full of amphipods, and the hallway is initially empty.

They give you a *diagram of the situation* (your puzzle input), including locations of each amphipod (`A`, `B`, `C`, or `D`, each of which is occupying an otherwise open space), walls (`#`), and open space (`.`).

For example:

```
#############
#...........#
###B#C#B#D###
  #A#D#C#A#
  #########
```

The amphipods would like a method to organize every amphipod into side rooms so that each side room contains one type of amphipod and the types are sorted `A`-`D` going left to right, like this:

```
#############
#...........#
###A#B#C#D###
  #A#B#C#D#
  #########
```

Amphipods can move up, down, left, or right so long as they are moving into an unoccupied open space. Each type of amphipod requires a different amount of *energy* to move one step: Amber amphipods require `1` energy per step, Bronze amphipods require `10` energy, Copper amphipods require `100`, and Desert ones require `1000`. The amphipods would like you to find a way to organize the amphipods that requires the *least total energy*.

However, because they are timid and stubborn, the amphipods have some extra rules:

* Amphipods will never *stop on the space immediately outside any room*. They can move into that space so long as they immediately continue moving. (Specifically, this refers to the four open spaces in the hallway that are directly above an amphipod starting position.)
* Amphipods will never *move from the hallway into a room* unless that room is their destination room *and* that room contains no amphipods which do not also have that room as their own destination. If an amphipod's starting room is not its destination room, it can stay in that room until it leaves the room. (For example, an Amber amphipod will not move from the hallway into the right three rooms, and will only move into the leftmost room if that room is empty or if it only contains other Amber amphipods.)
* Once an amphipod stops moving in the hallway, *it will stay in that spot until it can move into a room*. (That is, once any amphipod starts moving, any other amphipods currently in the hallway are locked in place and will not move again until they can move fully into a room.)

In the above example, the amphipods can be organized using a minimum of `*12521*` energy. One way to do this is shown below.

Starting configuration:

```
#############
#...........#
###B#C#B#D###
  #A#D#C#A#
  #########
```

One Bronze amphipod moves into the hallway, taking 4 steps and using `40` energy:

```
#############
#...B.......#
###B#C#.#D###
  #A#D#C#A#
  #########
```

The only Copper amphipod not in its side room moves there, taking 4 steps and using `400` energy:

```
#############
#...B.......#
###B#.#C#D###
  #A#D#C#A#
  #########
```

A Desert amphipod moves out of the way, taking 3 steps and using `3000` energy, and then the Bronze amphipod takes its place, taking 3 steps and using `30` energy:

```
#############
#.....D.....#
###B#.#C#D###
  #A#B#C#A#
  #########
```

The leftmost Bronze amphipod moves to its room using `40` energy:

```
#############
#.....D.....#
###.#B#C#D###
  #A#B#C#A#
  #########
```

Both amphipods in the rightmost room move into the hallway, using `2003` energy in total:

```
#############
#.....D.D.A.#
###.#B#C#.###
  #A#B#C#.#
  #########
```

Both Desert amphipods move into the rightmost room using `7000` energy:

```
#############
#.........A.#
###.#B#C#D###
  #A#B#C#D#
  #########
```

Finally, the last Amber amphipod moves into its room, using `8` energy:

```
#############
#...........#
###A#B#C#D###
  #A#B#C#D#
  #########
```

*What is the least energy required to organize the amphipods?*
=end
