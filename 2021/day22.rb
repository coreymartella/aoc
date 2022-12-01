#!/usr/bin/env ruby

require_relative 'day'
class Day22 < Day
  attr_accessor :state, :ons
  # data is [], graph is {k => []}, f is {k => 0}, h is {}, result,r,c,x,y are ints
  def part1
    debug!
    # v1, v2 = *input.split("\n\n")
    cubes = []
    each_line do |line, li|
      #on x=-29..23,y=-30..15,z=-3..49
      mode,x,y,z = *line.scan(/(on|off) x=(-?\d+..-?\d+),y=(-?\d+..-?\d+),z=(-?\d+..-?\d+)/).flatten
      x = eval("(#{x})")
      y = eval("(#{y})")
      z = eval("(#{z})")
      cubes << [[x,y,z,mode == "on"]]
      # overlaps = ons.keys.select do |ox,oy,oz|
      #   ox.overlaps?(x) && oy.overlaps?(y) && oz.overlaps?(z)
      # end.sort_by{|k| k.map(&:size).reduce(:*)}

      # if overlaps.blank?
      #   ons[[x,y,z]] = true if mode == "on"
      # end
      # # puts "L#{li} has #{overlaps.size} overlaps"
      # overlaps.each do |ox,oy,oz|
      #   breakdown_overlap(ox,oy,oz,x,y,z,mode)
      # end
      # ons.keys.combination(2).each do |(x1,y1,z1),(x2,y2,z2)|
      #   if x1.overlaps?(x2) && y1.overlaps?(y2) && z1.overlaps?(z2)
      #     breakdown_overlap(x1,y1,z1,x2,y2,z2,"on")
      #   end
      # end
      # dupes = ons.keys.combination(2).select do |(x1,y1,z1),(x2,y2,z2)|
      #   x1.overlaps?(x2) && y1.overlaps?(y2) && z1.overlaps?(z2)
      # end
      # if dupes.any?
      #   byebug
      #   puts "FOUND OVERLAPS of ONS #{dupes}"
      # end

      # puts "ONS: #{ons.keys} TOTAL=#{ons.keys.sum{ _1.map(&:size).reduce(:*)}}"
    end

    final_cubes = []
    cubes.each do |(x,y,z,on),v|
      adds = []
      final_cubes.each do |fc,fon|
        ix = x & fc[0]
        iy = y & fc[1]
        iz = z & fc[2]
        if ix&.any? && iy&.any? && iz&.any?
          adds << [[ix,iy,iz], !fon]
        end
      end
      if on
        adds << [[x,y,z],on]
      end
      final_cubes += adds
    end

    total = 0
    final_cubes.each do |(fc,on)|
      total += (on ? 1 : -1)*fc[0].size*fc[1].size*fc[2].size
    end
    puts "total is #{total}"

    #EX RIGHT 2758514936282235
    #MINE       39769202312460
    #MINE2      39769203361309
    #         3899223188116844

    #  436209325117291 too low
    #  521391211082261 too low
    # 9291286003113814 too high
    # puts "p1=#{state.keys.size}"

    puts "p2=#{ons.keys.sum{|x,y,z| x.size*y.size*z.size}}"
  end

  def breakdown_overlap(ox,oy,oz,x,y,z,mode)
    if mode == "on" && ox.cover?(x) && oy.cover?(y) && oz.cover?(z)
      #coverring found, just leave line alone
      puts "Overlap #{ox},#{oy},#{oz} COVERS #{x},#{y},#{z}"
      ons.delete([x,y,z])
      ons[[ox,oy,oz]] = true
      return
    elsif mode == "on" && x.cover?(ox) && y.cover?(oy) && z.cover?(oz)
      #coverring found, nuke the old one and grow it.
      puts "LINE #{x},#{y},#{z} COVERS EXISTING #{ox},#{oy},#{oz}"
      ons.delete([ox,oy,oz])
      ons[[x,y,z]] = true
      return
    end
    ix = ox & x
    oxl = (ox.min..ix.min-1)
    oxr = (ix.max+1..ox.max)
    xl = (x.min..ix.min-1)
    xr = (ix.max+1..x.max)

    iy = oy & y
    oyl = (oy.min..iy.min-1)
    oyr = (iy.max+1..oy.max)
    yl = (y.min..iy.min-1)
    yr = (iy.max+1..y.max)

    iz = oz & z
    ozl = (oz.min..iz.min-1)
    ozr = (iz.max+1..oz.max)
    zl = (z.min..iz.min-1)
    zr = (iz.max+1..z.max)

    if mode == "on"
      new_ons = [xl,ix,xr].select(&:any?).product([yl,iy,yr].select(&:any?),[zl,iz,zr].select(&:any?))
      old_ons = [oxl,ix,oxr].select(&:any?).product([oyl,iy,oyr].select(&:any?),[ozl,iz,ozr].select(&:any?))
      # puts "new/old ons: #{new_ons.size}+#{old_ons.size}=#{(new_ons+old_ons).uniq.size}"
      new_ons.select!{|x,y,z| old_ons.none?{|ox,oy,oz| ox.cover?(x) && oy.cover?(y) && oz.cover?(z)}}
      old_ons.select!{|x,y,z| new_ons.none?{|ox,oy,oz| ox.cover?(x) && oy.cover?(y) && oz.cover?(z)}}
      # puts "new/old ons after cover: #{new_ons.size}+#{old_ons.size}=#{(new_ons+old_ons).uniq.size}"
      (new_ons+old_ons).combination(2).each do |(x1,y1,z1),(x2,y2,z2)|
        if x1.overlaps?(x2) && y1.overlaps?(y2) && z1.overlaps?(z2)
          byebug
          puts "overlap of turning on (#{x1},#{y1},#{z1}),(#{x2},#{y2},#{z2})"
        end
      end
      ons.delete([ox,oy,oz])
      (new_ons + old_ons).each do |xn,yn,zn|
        ons[[xn,yn,zn]] = true
      end
    else
      ons.delete([ox,oy,oz])
      [oxl,ix,oxr].select(&:any?).product([oyl,iy,oyr].select(&:any?),[ozl,iz,ozr].select(&:any?)).each do |xn,yn,zn|
        next if xn == ix && yn == iy && zn == iz
        next if x.cover?(xn) && y.cover?(yn) && z.cover?(zn)
        ons[[xn,yn,zn]] = true
      end
    end

    # # puts "DELETING #{ox.size*oy.size*oz.size} TOTAL=#{ons.keys.sum{|k| k.map(&:size).reduce(:*)}}"

    # ons.delete([ox,oy,oz])
    # [oxl,ix,oxr].product([oyl,iy,oyr],[ozl,iz,ozr]).each do |xn,yn,zn|
    #   ons[[xn,yn,zn]] = true if xn.any? && yn.any? && zn.any?
    # end

    # # puts "AFTER LEFTOVER RESTORE TOTAL=#{ons.keys.sum{|k| k.map(&:size).reduce(:*)}}"
    # if mode == "on"
    #   # turn on the new parts intersection
    #   [xl,ix,xr].product([yl,iy,yr],[zl,iz,zr]).each do |xn,yn,zn|
    #     ons[[xn,yn,zn]] = true if xn.any? && yn.any? && zn.any?
    #   end
    #   # puts "AFTER INTERSECTION+ADDITION TOTAL=#{ons.keys.sum{|k| k.map(&:size).reduce(:*)}}"
    # else
    #   #delete the intersection, thats been turned off
    #   ons.delete([ix,iy,iz])
    # end
  end

  # def part2
  #   # debug!
  # end
end
=begin

=end

if __FILE__ == $0
  ENV["INPUT"] = ARGV.last || __FILE__.split("/").last.gsub(".rb",'')
  Day22.new.part1
end