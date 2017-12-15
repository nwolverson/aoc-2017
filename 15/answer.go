package main

import "fmt"

func answer1() {
	var a, b, matches = 591, 393, 0
	for i := 0; i < 40000000; i++ {
		a = (a * 16807) % 2147483647
		b = (b * 48271) % 2147483647
		if uint16(a) == uint16(b) {
			matches++
		}
	}
	fmt.Println(matches)
}

func answer2() {
	var a, b, matches = 591, 393, 0
	for i := 0; i < 5000000; i++ {
		for {
			a = (a * 16807) % 2147483647
			if a % 4 == 0 {
				break
			}
		}
		for {
			b = (b * 48271) % 2147483647
			if b % 8 == 0 {
				break
			}
		}
		if uint16(a) == uint16(b) {
			matches++
		}
	}
	fmt.Println(matches)
}

func main() {
	answer1()
	answer2()
}