# HTTP API for downloading puzzles
class AocApi
  include HTTParty
  base_uri 'https://adventofcode.com'
  # debug_output $stdout # <= will spit out all request details to the console

  def initialize(year, session)
    @year = year
    @options = { headers: { 'Cookie' => "session=#{session}" } }
  end

  def data(day_number)
    self.class.get("/#{@year}/day/#{day_number}/input", @options)
  end

  def problem(day_number)
    @problem_cache ||= {}

    @problem_cache[day_number] ||= begin
      resp = self.class.get("/#{@year}/day/#{day_number}", @options)
      doc = Nokogiri::HTML5(resp.body)
      Upmark.convert(doc.css("article.day-desc").inner_html)
        .gsub("<pre><code>","```\n")
        .gsub("</code></pre>","```\n")
        .gsub("<code>","`")
        .gsub("</code>","`")
        .gsub("<em>","*")
        .gsub("</em>","*")
    end
  end

  def answer(day:,level:, answer: )
    puts "submitting /#{@year}/day/#{day}/answer for level #{level} with value #{answer}"
    resp = self.class.post("/#{@year}/day/#{day}/answer", {**@options, body: {
        level: level,
        answer: answer,
    }})
    doc = Nokogiri::HTML5(resp.body)
    result = Upmark.convert(doc.css("article").inner_html)
      .gsub("<pre><code>","```\n")
      .gsub("</code></pre>","```\n")
      .gsub("<code>","`")
      .gsub("</code>","`")
      .gsub("<em>","*")
      .gsub("</em>","*")
    puts result
    result
  end

  def examples(day_number)
    p = problem(day_number)
    p.scan(/\`\`\`([^\`]+)\`\`\`/).map(&:first).map{|ex| ex.gsub("*",'').strip}
  end
end
