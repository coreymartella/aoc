input = "reyedfim"
index = 0
password = Array.new(8,'_')
animation = ['-','\\','|','/', '-','\\']
filled = 0
while filled < 8
  hash = Digest::MD5.hexdigest("#{input}#{index}")
  if hash =~ /^00000/
    pos = hash.chars[5].to_i(16)
    char = hash.chars[6]
    if pos < password.size && password[pos] == '_'
      filled += 1
      password[pos] = char 
    end
  end
  print "\r#{animation[(index/10000) % animation.size]} #{password.join}" if index % 10000 == 0
  index += 1
end
puts