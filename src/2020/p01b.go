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

		var nums []int
		sums := map[int64][]int{}

    scanner := bufio.NewScanner(file)
    scanner.Split(bufio.ScanWords)
    for scanner.Scan() {
			x, err := strconv.Atoi(scanner.Text())
			if err != nil {
			    return result, err
			}
			nums = append(nums, x)
		}

		for _, x := range nums {
			for _, y := range nums {
				sums[x+y] = [x,y]
    }
		for _, x := range nums {
			if sums[2020-x] {
				fmt.Printf("FOUND %v * %v = %v\n", x, sums[2020-x])
				break;
			}
		}

    if err := scanner.Err(); err != nil {
        log.Fatal(err)
		}
	}