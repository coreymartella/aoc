package main

import (
    "bufio"
    "fmt"
    "log"
		"os"
		"strconv"
)
//  Find the two entries that sum to 2020; what do you get if you multiply them together?
func main()  {
    file, err := os.Open("data/p1.txt")
    if err != nil {
        log.Fatal(err)
    }
    defer file.Close()

		nums := map[int64]bool{}
    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
				val, err := strconv.ParseInt(scanner.Text(), 10, 32)
				nums[val] = true
				if err != nil {
						log.Fatal(err)
				}
				if nums[2020-val] == true {
					fmt.Printf("FOUND %v * %v = %v\n", val, 2020-val, val*(2020-val))
					break;
				}
    }

    if err := scanner.Err(); err != nil {
        log.Fatal(err)
		}
	}