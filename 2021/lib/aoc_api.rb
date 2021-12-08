# HTTP API for downloading puzzles
class AocApi
  include HTTParty
  base_uri 'adventofcode.com'

  def initialize(year, session)
    @year = year
    @options = { headers: { 'Cookie' => "session=#{session}" } }
  end

  def day(day_number)
    self.class.get("/#{@year}/day/#{day_number}/input", @options)
  end

  def problem(day_number)
    resp = self.class.get("/#{@year}/day/#{day_number}", @options)
    doc = Nokogiri::HTML5(resp.body)
    Upmark.convert(doc.css("article.day-desc").inner_html).gsub("<pre><code>","```\n").gsub("</code></pre>","```\n").gsub("<code>","`").gsub("</code>","`")
  end
end
