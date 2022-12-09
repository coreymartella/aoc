#!/usr/bin/env ruby
require_relative 'day'
class Day07 < Day
  # data is [], graph is {k => []}, f is {k => 0}, h is {}, answer,r,c,x,y are ints
  attr_accessor :sizes, :dirs
  def part1
    # debug!
    #
    # v1, v2 = *input.split("\n\n")
    @dirs = {}
    @sizes = Hash.new(0)
    dir = "/"
    commands = input.split("\n\$ ")
    commands.each do |lines|
      command,output = lines.split("\n",2)
      if (dest = command[/cd (.*)/, 1])
        if dest == ".."
          dir = dir.split("/")[0..-2].join("/")
        elsif dest == "/"
          dir = "/"
        else
          dir = "#{dir}/#{dest}".gsub("//","/")
        end
      elsif command == "ls"
        dirs[dir] ||= true
        output.split("\n").each do |ls|
          if (subdir = ls[/dir (.*)/,1])
            dirs["#{dir}/#{subdir}"] = true
          elsif (size,file = ls.split(" "))
            add_size("#{dir}/#{file}".gsub("//","/"), size.to_i)
          end
        end
      end
    end
    self.answer = dirs.keys.sum(0) do |dir|
      @sizes[dir] < 100_000 ? @sizes[dir] : 0
    end

    # puts "Answer is #{answer}... Submitting..."
    # submit_answer(part: 1, answer: answer)
  end

  def add_size(path, size)
    parts = path.split("/")
    parts.each_with_index do |part,i|
      @sizes[i == 0 ? "/" : parts[0..i].join("/")] += size
    end
  end

  def part2
    part1
    disk_size = 70_000_000
    needed = 30_000_000
    free = disk_size - @sizes["/"]
    puts "free space is #{free}"
    to_free = needed - free
    puts "need to free up #{to_free}"
    self.answer = disk_size
    dirs.keys.each do |dir|
      size = sizes[dir]
      if size >= to_free && size < answer
        puts "found #{dir} of size #{size} to free up vs #{answer}"
        self.answer = size
      end
    end
    # # debug!
    puts "Answer is #{answer}... Submitting..."
    submit_answer(part: 2, answer: answer)
  end
end
if __FILE__ == $0
  ENV["INPUT"] = ARGV.last || __FILE__.split("/").last.gsub(".rb",'')
  d = Day07.new
  d.respond_to?(:part2) ? d.part2 : d.part1
end

=begin
## --- Day 7: No Space Left On Device ---You can hear birds chirping and raindrops hitting leaves as the expedition proceeds. Occasionally, you can even hear much louder sounds in the distance; how big do the animals get out here, anyway?

The device the Elves gave you has problems with more than just its communication system. You try to run a system update:

{:element=>{:name=>"pre", :attributes=>[], :children=>[{:element=>{:name=>"code"@386, :attributes=>[], :children=>["$ system-update --please --pretty-please-with-sugar-on-top\n", ["Error"], ": No space left on device\n"], :ignore=>true}}], :ignore=>true}}
Perhaps you can delete some files to make space for the update?

You browse around the filesystem to assess the situation and save the resulting terminal output (your puzzle input). For example:

```
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
```

The filesystem consists of a tree of files (plain data) and directories (which can contain other directories or files). The outermost directory is called `/`. You can navigate around the filesystem, moving into or out of directories and listing the contents of the directory you're currently in.

Within the terminal output, lines that begin with `$` are *commands you executed*, very much like some modern computers:

* `cd` means *change directory*. This changes which directory is the current directory, but the specific result depends on the argument:
* `cd x` moves *in* one level: it looks in the current directory for the directory named `x` and makes it the current directory.
* `cd ..` moves *out* one level: it finds the directory that contains the current directory, then makes that directory the current directory.
* `cd /` switches the current directory to the outermost directory, `/`.

* `ls` means *list*. It prints out all of the files and directories immediately contained by the current directory:
* `123 abc` means that the current directory contains a file named `abc` with size `123`.
* `dir xyz` means that the current directory contains a directory named `xyz`.

Given the commands and output in the example above, you can determine that the filesystem looks visually like this:

```
- / (dir)
  - a (dir)
    - e (dir)
      - i (file, size=584)
    - f (file, size=29116)
    - g (file, size=2557)
    - h.lst (file, size=62596)
  - b.txt (file, size=14848514)
  - c.dat (file, size=8504156)
  - d (dir)
    - j (file, size=4060174)
    - d.log (file, size=8033020)
    - d.ext (file, size=5626152)
    - k (file, size=7214296)
```

Here, there are four directories: `/` (the outermost directory), `a` and `d` (which are in `/`), and `e` (which is in `a`). These directories also contain files of various sizes.

Since the disk is full, your first step should probably be to find directories that are good candidates for deletion. To do this, you need to determine the *total size* of each directory. The total size of a directory is the sum of the sizes of the files it contains, directly or indirectly. (Directories themselves do not count as having any intrinsic size.)

The total sizes of the directories above can be found as follows:

* The total size of directory `e` is *584* because it contains a single file `i` of size 584 and no other directories.
* The directory `a` has total size *94853* because it contains files `f` (size 29116), `g` (size 2557), and `h.lst` (size 62596), plus file `i` indirectly (`a` contains `e` which contains `i`).
* Directory `d` has total size *24933642*.
* As the outermost directory, `/` contains every file. Its total size is *48381165*, the sum of the size of every file.

To begin, find all of the directories with a total size of *at most 100000*, then calculate the sum of their total sizes. In the example above, these directories are `a` and `e`; the sum of their total sizes is `*95437*` (94853 + 584). (As in this example, this process can count files more than once!)

Find all of the directories with a total size of at most 100000. *What is the sum of the total sizes of those directories?*
=end
