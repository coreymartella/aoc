Bundler.require
require 'pp'
class Array
  def histogram
    group_by(&:itself).map { |k, v| [k, v.size] }.to_h
  end
end
