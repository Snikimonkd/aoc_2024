package main

import utils "aoc_2024:utils"

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"


first :: proc(v: [dynamic]utils.Vector2) {
	utils.bubble_sort(v)

	c: int = 0
	for i := 0; i < len(v); i += 1 {
		v := max(v[i].x, v[i].y) - min(v[i].x, v[i].y)
		c += v
	}

	fmt.println("first is: ", c)
}

second :: proc(v: [dynamic]utils.Vector2) {
	c: int = 0

	for i: int = 0; i < len(v); i += 1 {
		for j: int = 0; j < len(v); j += 1 {
			if v[i].x == v[j].y {
				c += v[i].x
			}
		}
	}

	fmt.println("second is: ", c)
}

main :: proc() {
	lines, err := utils.read_file("./inputs/1_in.txt")
	if err != {} {
		fmt.println("can't open file: %v", err)
		os.exit(-1)
	}

	v: [dynamic]utils.Vector2 = {}

	for i := 0; i < len(lines); i += 1 {
		if lines[i] == "" {
			continue
		}

		vals := strings.split(lines[i], "   ")
		if len(vals) != 2 {
			fmt.println("len(vals) != 2: ", vals)
			os.exit(-1)
		}

		val0, val1 := strconv.atoi(vals[0]), strconv.atoi(vals[1])
		append(&v, utils.Vector2{val0, val1})
	}

	first(v)
	second(v)
}
