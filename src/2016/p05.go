package main

import (
    "crypto/md5"
    "encoding/hex"
    "strconv"
    "strings"
    "fmt"
)

func main() {
  input := "reyedfim"
  index := 0
  filled := 0
  animation := [4]string{"-", "\\", "|", "/"}
  var pass [8]string
  pass = make([]string, 8)
  for {
    hash := md5.Sum([]byte(fmt.Sprintf("%s%d", input, index)))
    digest := hex.EncodeToString(hash[:])
    // fmt.Println("%d ==> %s", index, digest[0:5])
    if digest[0:5] == "00000" {
      pos, _ := strconv.ParseInt(digest[5:6], 16, 0)
      if pos < int64(len(pass)) && (pass[pos] == "") {
        filled += 1
        char := digest[6:7]
        pass[pos] = char
        fmt.Printf("%d ==> %s pos: %d char %s\n", index, digest, pos, char)
        // break;
      }
    }
    if index % 10000 == 0 || filled >= 8 {
      fmt.Printf("\r%s %s %d", animation[(index/10000) % len(animation)], strings.Join(pass,""), index)
    }
    index += 1
  }
}