package main

import utils "aoc_2024:utils"

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

Dir :: enum {
	Asc,
	Desc,
}

check_valid :: proc(v: [dynamic]int) -> bool {
	ok := true

	if len(v) == 1 {
		return true
	}

	startDir := Dir.Asc
	if v[0] > v[1] {
		startDir = Dir.Desc
	}

	for j := 0; j < len(v) - 1; j += 1 {
		diff := max(v[j], v[j + 1]) - min(v[j], v[j + 1])
		if diff == 0 || diff > 3 {
			ok = false
			break
		}

		currentDir := Dir.Asc
		if v[j] > v[j + 1] {
			currentDir = Dir.Desc
		}
		if currentDir != startDir {
			ok = false
			break
		}
	}

	return ok
}


first :: proc(v: [dynamic][dynamic]int) {
	c := 0
	for i := 0; i < len(v); i += 1 {
		ok := check_valid(v[i])
		c += ok ? 1 : 0
	}

	fmt.println("first is: ", c)
}


check_valid_2 :: proc(v: [dynamic]int) -> bool {
	ok := true

	if len(v) == 1 {
		return true
	}

	broken := 0

	left := 0
	right := 1

	// wtf
	startDir := v[left] > v[right] ? Dir.Desc : Dir.Asc

	for right < len(v) {
		diff := max(v[left], v[right]) - min(v[left], v[right])
		if diff == 0 || diff > 3 {
			ok = false
			break
		}

	}


	//	currentDir := Dir.Asc
	//	if v[left] > v[right] {
	//		currentDir = Dir.Desc
	//	}
	//	if currentDir != startDir {
	//		ok = false
	//		break
	//	}

	return ok
}

second :: proc(v: [dynamic][dynamic]int) {
	c := 0
	for i := 0; i < len(v); i += 1 {

		c += ok ? 1 : 0
	}

	fmt.println("first is: ", c)
}

main :: proc() {
	lines, err := utils.read_file("./inputs/2_in.txt")
	if err != {} {
		fmt.println("can't open file: %v", err)
		os.exit(-1)
	}

	v: [dynamic][dynamic]int = {}

	for i := 0; i < len(lines); i += 1 {
		if lines[i] == "" {
			continue
		}

		vals := strings.split(lines[i], " ")
		buf: [dynamic]int
		for i := 0; i < len(vals); i += 1 {
			append(&buf, strconv.atoi(vals[i]))
		}

		append(&v, buf)
	}

	first(v)
	second(v)
}