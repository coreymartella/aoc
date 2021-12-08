module Year2021
  class Problem
    attr_accessor :debug
    def debug!
      @debug = true
    end
    def day
      @day ||= self.class.name.demodulize[/\d+/].to_i
    end
    def lines
      file = nil
      file = if @debug
        "data/2021/day#{self.class.name.split("::").last[/\d+/]}.test"
      end
      file = nil if file && !File.exist?(file)
      file ||= "data/2021/day#{self.class.name.split("::").last[/\d+/]}"
      File.readlines(file)
    end
    def print(msg=nil)
      return unless debug
      msg ||= yield if block_given?
      Kernel.print(msg)
    end
    def puts(msg=nil)
      return unless debug
      msg ||= yield if block_given?
      Kernel.puts(msg)
    end
    def puts!(msg=nil)
      msg ||= yield if block_given?
      Kernel.puts(msg)
    end
  end
end