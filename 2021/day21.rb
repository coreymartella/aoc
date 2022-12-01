class Day21 < Day
  # data is [], graph is {k => []}, f is {k => 0}, h is {}, result,r,c,x,y are ints
  def part1
    # debug!
    # Players take turns moving. On each player's turn, the player rolls the die three times and adds up the results. Then, the player moves their pawn that many times forward around the track (that is, moving clockwise on spaces in order of increasing value, wrapping back around to 1 after 10). So, if a player is on space 7 and they roll 2, 2, and 1, they would move forward 5 times, to spaces 8, 9, 10, 1, and finally stopping on 2.

    pos = {}
    scores = {}
    states = Hash.new(0) #[p1p,p1s,p2p,p2s] => universe Count

    # debug!
    #
    start_state = []
    each_line do |line, li|
      player,start = *line.scan(/Player (\d+) starting position: (\d+)/).flatten.map(&:to_i)
      start_state += [start,0]
    end
    states[start_state] = 1
    #On each player's turn, the player rolls the die three times and adds up the results

    rolls = {3=>1, 4=>3, 5=>6, 6=>7, 7=>6, 8=>3, 9=>1}
    check_states = Set.new
    check_states << start_state
    final_states = Set.new
    while check_states.any?
      puts "check_states=#{check_states.size} win_states=#{states.size-check_states.size} total_unis=#{states.values.sum}"
      (0..1).each do |pi|
        pos_k = pi*2
        score_k = pi*2+1
        new_check_states = Set.new
        new_states = Hash.new(0)
        final_states.each do |k|
          new_states[k] = states[k] #copy over final states
        end
        rolls.each do |roll,unis|
          # this roll happens in old universe
          #increment all states
          check_states.each do |state|
            new_state = state.dup
            new_state[pos_k] = (state[pos_k]+roll-1) % 10 + 1
            new_state[score_k] += new_state[pos_k]
            if new_state == state
              byebug
            end
            if new_state[1] < 21 && new_state[3] < 21
              #need to check this state
              new_check_states << new_state
            else
              final_states << new_state
            end
            #seed the universe with anyone already in that state
            # new_states[new_state] = states[new_state] unless new_states.key?(new_state)
            #move them all out of the old universe into the new
            new_states[new_state] += (states[state] * unis)
          end
        end
        # byebug
        states = new_states
        check_states = new_check_states
      end
      # pos.keys.each do |player|
      #   dice = []
      #   3.times do |subroll|
      #     rolls += 1
      #     dice << ((rolls-1) % 100 + 1)
      #   end
      #   dice_total = dice.sum
      #   pos[player] = (pos[player]+dice_total-1) % 10 + 1
      #   scores[player] += pos[player]
      #   puts "Player #{player} rolls #{dice.join("+")} and moves to space #{pos[player]} for a total score of #{scores[player]}."
      #   if scores[player] >= 1000
      #     return scores.values.min*rolls
      #   end
      # end
    end
    # max_iters = 10
    # 1.upto(max_iters) do |iter|
    #
    # end

    #scores.values.min*rolls
    byebug
    p1_wins = states.sum{|k,unis| k[1] >= 21 && k[1] > k[3] ? unis : 0}
    p2_wins = states.sum{|k,unis| k[3] >= 21 && k[3] > k[1] ? unis : 0}
    # 128655180498 too low
    [p1_wins,p2_wins].max
  end

  # def part2
  #   # debug!
  # end
end
=begin

=end
