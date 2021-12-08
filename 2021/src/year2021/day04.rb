module Year2021
  class Day04
    def part1(input)
      # input = File.read("./data/2021/day04.test")

      lines = input.split("\n")
      boards = []
      board_index = 0
      draw = lines.shift.split(",").map(&:to_i)
      lines.each_with_index do |line,index|
        if line != ""
          board = (boards[board_index] ||= {})
          board_row = board.keys.size / 5
          line.split(" ").map(&:to_i).each_with_index do |num,col|
            board[num] = {row: board_row, col: col, marked: false}
          end
        else
          board_index += 1 if boards[board_index] != nil && boards[board_index] != []
        end
      end
      board_indexes = {}
      boards.each_with_index do |board,i|
        board.keys.each do |num|
          board_indexes[num] ||= []
          board_indexes[num] << i
        end
      end
      last_winning_board = nil
      draw.each_with_index do |num,i|
        puts "draw#{i+1}_of_#{draw.size}=#{num} boards=#{board_indexes[num]}"
        board_indexes[num].each do |board_index|
          board = boards[board_index]
          board[num][:marked] = true
          puts "board#{num} after #{num}"
          pp board
          if bingo?(board)
            puts "bingo board_index=#{board_index}"
            unmarked = board.keys.select{|num| !board[num][:marked]}.sum
            return unmarked * num
          end
        end
      end
    end

    def part2(input)
            lines = input.split("\n")
      boards = []
      board_index = 0
      draw = lines.shift.split(",").map(&:to_i)
      lines.each_with_index do |line,index|
        if line != ""
          board = (boards[board_index] ||= {})
          board_row = board.keys.size / 5
          line.split(" ").map(&:to_i).each_with_index do |num,col|
            board[num] = {row: board_row, col: col, marked: false}
          end
        else
          board_index += 1 if boards[board_index] != nil && boards[board_index] != []
        end
      end
      board_indexes = {}
      boards.each_with_index do |board,i|
        board.keys.each do |num|
          board_indexes[num] ||= []
          board_indexes[num] << i
        end
      end
      last_winning_board = nil
      last_winning_num = nil
      draw.each_with_index do |num,i|
        puts "draw#{i+1}_of_#{draw.size}=#{num} boards=#{board_indexes[num]}"
        board_indexes[num].each do |board_index|
          board = boards[board_index]
          next if !board
          board[num][:marked] = true
          puts "board#{num} after #{num}"
          if bingo?(board)
            boards[board_index] = nil
            last_winning_board = board
            last_winning_num = num
          end
        end
      end
      unmarked = last_winning_board.keys.select{|num| !last_winning_board[num][:marked]}.sum
      return unmarked * last_winning_num

    end

    def bingo?(board)
      board_dim = (board.size**0.5).to_i
      0.upto(board_dim-1) do |rc|
        puts "checking bingo on #{rc} against #{board}"
        if board.keys.count{|k| board[k][:row] == rc && board[k][:marked]} == board_dim ||
          board.keys.count{|k| board[k][:col] == rc && board[k][:marked]} == board_dim
          return true
        end
      end
      false
    end
  end
end

=begin
## --- Day 4: Giant Squid ---You're already almost 1.5km (almost a mile) below the surface of the ocean, already so deep that you can't see any sunlight. What you *can* see, however, is a giant squid that has attached itself to the outside of your submarine.

Maybe it wants to play [bingo](https://en.wikipedia.org/wiki/Bingo_(American_version) "")?

Bingo is played on a set of boards each consisting of a 5x5 grid of numbers. Numbers are chosen at random, and the chosen number is *marked* on all boards on which it appears. (Numbers may not appear on all boards.) If all numbers in any row or any column of a board are marked, that board *wins*. (Diagonals don't count.)

The submarine has a *bingo subsystem* to help passengers (currently, you and the giant squid) pass the time. It automatically generates a random order in which to draw numbers and a random set of boards (your puzzle input). For example:

```
7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7
```

After the first five numbers are drawn (`7`, `4`, `9`, `5`, and `11`), there are no winners, but the boards are marked as follows (shown here adjacent to each other to save space):

```
22 13 17 <em>11</em>  0         3 15  0  2 22        14 21 17 24  <em>4</em>
 8  2 23  <em>4</em> 24         <em>9</em> 18 13 17  <em>5</em>        10 16 15  <em>9</em> 19
21  <em>9</em> 14 16  <em>7</em>        19  8  <em>7</em> 25 23        18  8 23 26 20
 6 10  3 18  <em>5</em>        20 <em>11</em> 10 24  <em>4</em>        22 <em>11</em> 13  6  <em>5</em>
 1 12 20 15 19        14 21 16 12  6         2  0 12  3  <em>7</em>
```

After the next six numbers are drawn (`17`, `23`, `2`, `0`, `14`, and `21`), there are still no winners:

```
22 13 <em>17</em> <em>11</em>  <em>0</em>         3 15  <em>0</em>  <em>2</em> 22        <em>14</em> <em>21</em> <em>17</em> 24  <em>4</em>
 8  <em>2</em> <em>23</em>  <em>4</em> 24         <em>9</em> 18 13 <em>17</em>  <em>5</em>        10 16 15  <em>9</em> 19
<em>21</em>  <em>9</em> <em>14</em> 16  <em>7</em>        19  8  <em>7</em> 25 <em>23</em>        18  8 <em>23</em> 26 20
 6 10  3 18  <em>5</em>        20 <em>11</em> 10 24  <em>4</em>        22 <em>11</em> 13  6  <em>5</em>
 1 12 20 15 19        <em>14</em> <em>21</em> 16 12  6         <em>2</em>  <em>0</em> 12  3  <em>7</em>
```

Finally, `24` is drawn:

```
22 13 <em>17</em> <em>11</em>  <em>0</em>         3 15  <em>0</em>  <em>2</em> 22        <em>14</em> <em>21</em> <em>17</em> <em>24</em>  <em>4</em>
 8  <em>2</em> <em>23</em>  <em>4</em> <em>24</em>         <em>9</em> 18 13 <em>17</em>  <em>5</em>        10 16 15  <em>9</em> 19
<em>21</em>  <em>9</em> <em>14</em> 16  <em>7</em>        19  8  <em>7</em> 25 <em>23</em>        18  8 <em>23</em> 26 20
 6 10  3 18  <em>5</em>        20 <em>11</em> 10 <em>24</em>  <em>4</em>        22 <em>11</em> 13  6  <em>5</em>
 1 12 20 15 19        <em>14</em> <em>21</em> 16 12  6         <em>2</em>  <em>0</em> 12  3  <em>7</em>
```

At this point, the third board *wins* because it has at least one complete row or column of marked numbers (in this case, the entire top row is marked: `*14 21 17 24  4*`).

The *score* of the winning board can now be calculated. Start by finding the *sum of all unmarked numbers* on that board; in this case, the sum is `188`. Then, multiply that sum by *the number that was just called* when the board won, `24`, to get the final score, `188 * 24 = *4512*`.

To guarantee victory against the giant squid, figure out which board will win first. *What will your final score be if you choose that board?*
=end
