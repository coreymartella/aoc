var data = "do shash'owania";
var crypto = require('crypto');
var console = require('console');
input = "reyedfim"
index = 0
password = new Array(8)
animation = ['-','\\','|','/', '-','\\']
filled = 0
for {
  hash = crypto.createHash('md5').update(input + index).digest("hex");
  if (hash.substring(0,5) == "00000") {
    console.log("")
  }
  index += 1
}
// while filled < 8
//   hash = Digest::MD5.hexdigest("#{input}#{index}")
//   if hash =~ /^00000/
//     pos = hash.chars[5].to_i(16)
//     char = hash.chars[6]
//     if pos < password.size && password[pos] == '_'
//       filled += 1
//       password[pos] = char 
//     end
//   end
//   print "\r#{animation[(index/10000) % animation.size]} #{password.join}" if index % 10000 == 0
//   index += 1
end
puts