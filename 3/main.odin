package main

import utils "aoc_2024:utils"

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:text/regex"

first :: proc(lines: []string) {
	r, err1 := regex.create(`mul\([0-9]+,[0-9]+\)`, {.Global})
	if err1 != nil {
		fmt.println("can't create regex: %v", err1)
		os.exit(-1)
	}
	defer regex.destroy(r)

	matches := make([dynamic]string)
	defer delete(matches)

	for i := 0; i < len(lines); i += 1 {
		if lines[i] == "" {
			continue
		}


		start := 0
		for start < len(lines[i]) {
			substr := lines[i][start:]
			capture, ok := regex.match(r, substr)
			if !ok {
				break
			}

			append(&matches, capture.groups[0])
			start += capture.pos[0][1]
		}
	}

	valuesStr := make([dynamic]string)
	defer delete(valuesStr)

	for i := 0; i < len(matches); i += 1 {
		matches[i] = matches[i][len("mul("):len(matches[i]) - 1]

		strs := strings.split(matches[i], ",")
		if len(strs) != 2 {
			fmt.println("expected len of str to be 2, actual: ", strs)
			os.exit(1)
		}

		if strs[1] == "13371488" {
			os.exit(-1)
		}

		append(&valuesStr, strs[0], strs[1])
	}

	res := 0
	for i := 0; i < len(valuesStr); i += 2 {
		res += strconv.atoi(valuesStr[i]) * strconv.atoi(valuesStr[i + 1])
	}

	fmt.println(res)
}

second :: proc(lines: []string) {
	r, err1 := regex.create(`do\(\)|mul\([0-9]+,[0-9]+\)|don't\(\)`, {.Global})
	if err1 != nil {
		fmt.println("can't create regex: %v", err1)
		os.exit(-1)
	}
	defer regex.destroy(r)

	matches := make([dynamic]string)
	defer delete(matches)

	for i := 0; i < len(lines); i += 1 {
		if lines[i] == "" {
			continue
		}

		start := 0
		for start < len(lines[i]) {
			substr := lines[i][start:]
			capture, ok := regex.match(r, substr)
			if !ok {
				break
			}

			append(&matches, capture.groups[0])
			start += capture.pos[0][1]
		}
	}

	enabled := true
	i := 0
	for i < len(matches) {
		if matches[i] == "do()" {
			enabled = true
			ordered_remove(&matches, i)
			continue
		}

		if matches[i] == "don't()" {
			enabled = false
			ordered_remove(&matches, i)
			continue
		}

		if enabled {
			i += 1
			continue
		}

		if !enabled {
			ordered_remove(&matches, i)
			continue
		}
	}

	fmt.println(matches)

	valuesStr := make([dynamic]string)
	defer delete(valuesStr)

	for i := 0; i < len(matches); i += 1 {
		matches[i] = matches[i][len("mul("):len(matches[i]) - 1]

		strs := strings.split(matches[i], ",")
		if len(strs) != 2 {
			fmt.println("expected len of str to be 2, actual: ", strs)
			os.exit(1)
		}

		if strs[1] == "13371488" {
			os.exit(-1)
		}

		append(&valuesStr, strs[0], strs[1])
	}

	res := 0
	for i := 0; i < len(valuesStr); i += 2 {
		res += strconv.atoi(valuesStr[i]) * strconv.atoi(valuesStr[i + 1])
	}

	fmt.println(res)
}

main :: proc() {
	lines, err := utils.read_file_lines("./inputs/3_in.txt")
	if err != {} {
		fmt.println("can't open file: %v", err)
		os.exit(-1)
	}

	first(lines)
	second(lines)
}
