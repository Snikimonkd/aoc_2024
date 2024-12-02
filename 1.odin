package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

CustomError :: enum {
	None,
	BrokenVal,
}

Error :: union #shared_nil {
	CustomError,
	os.Error,
}

Vector2 :: distinct [2]int

read_file :: proc(filename: string) -> (v: [dynamic]Vector2, err: Error) {
	buf := os.read_entire_file_from_filename_or_err(filename) or_return

	str: string = string(buf)
	lines := strings.split(str, "\n")

	for i := 0; i < len(lines); i += 1 {
		if lines[i] == "" {
			continue
		}

		vals := strings.split(lines[i], "   ")
		if len(vals) != 2 {
			fmt.println(vals)
			return {}, .BrokenVal
		}

		val0, val1 := strconv.atoi(vals[0]), strconv.atoi(vals[1])
		append(&v, Vector2{val0, val1})
	}

	return v, nil
}

bubble_sort :: proc(v: [dynamic]Vector2) {
	for i := 0; i < len(v); i += 1 {
		for j := i + 1; j < len(v); j += 1 {
			if v[i].x > v[j].x {
				v[i].x, v[j].x = v[j].x, v[i].x
			}
			if v[i].y > v[j].y {
				v[i].y, v[j].y = v[j].y, v[i].y
			}
		}
	}
}

first :: proc(v: [dynamic]Vector2) {
	bubble_sort(v)

	c: int = 0
	for i := 0; i < len(v); i += 1 {
		v := max(v[i].x, v[i].y) - min(v[i].x, v[i].y)
		c += v
	}

	fmt.println("first is: ", c)
}

second :: proc(v: [dynamic]Vector2) {
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
	v, err := read_file("./inputs/1_in.txt")
	if err != {} {
		fmt.println("can't open file: %v", err)
		os.exit(-1)
	}

	first(v)
	second(v)
}
