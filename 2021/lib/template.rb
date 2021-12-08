require 'fileutils'

# Template management
class Template
  def self.create_templates(year, day)
    create_source(year, day)
  end

  def self.create_source(year, day)
    source_directory = PuzzleSource.puzzle_source_directory(year)
    aoc_api = AocApi.new(year, ENV['AOC_COOKIE'])
    problem_content = aoc_api.problem(day)
    FileUtils.mkdir_p(source_directory) if !Dir.exist?(source_directory)
    PuzzleInput.skip_if_exists(PuzzleSource.puzzle_source_path(year, day)) do
      src_file = PuzzleSource.puzzle_source_path(year, day)

      File.open(src_file, 'w') do |f|
        f.write PuzzleSource.puzzle_source(year, day, problem_content)
      end
      puts "Created #{src_file}"
    end
  end
end
