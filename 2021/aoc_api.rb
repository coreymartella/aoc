# HTTP API for downloading puzzles
class AocApi
  include HTTParty
  base_uri 'adventofcode.com'

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

  def answer(level,value)
      resp = self.class.post("/#{@year}/day/#{@day}/answer", {**@options, body: {
          level: level,
          answer: value,
      }})
      puts resp.body
      doc = Nokogiri::HTML5(resp.body)
  end

  def examples(day_number)
    p = problem(day_number)
    p.scan(/\`\`\`([^\`]+)\`\`\`/).map(&:first).map{|ex| ex.gsub("*",'').strip}
  end
end
