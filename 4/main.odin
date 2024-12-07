package main

import utils "aoc_2024:utils"

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:text/regex"

first :: proc(lines: []string) {
	// horizontal ->
	c := 0
	for i := 0; i < len(lines); i += 1 {
		for j := 0; j < len(lines[i]) - 3; j += 1 {
			if lines[i][j:j + 4] == "XMAS" {
				c += 1
			}
		}
	}

	// horizontal <-
	for i := 0; i < len(lines); i += 1 {
		for j := 4; j <= len(lines[i]); j += 1 {
			if lines[i][j - 4:j] == "SAMX" {
				c += 1
			}
		}
	}

	// verticaly down
	for i := 0; i < len(lines) - 4; i += 1 {
		for j := 0; j < len(lines[i]); j += 1 {
			buf: [4]u8 = {}
			buf[0] = lines[i][j]
			buf[1] = lines[i + 1][j]
			buf[2] = lines[i + 2][j]
			buf[3] = lines[i + 3][j]
			if string(buf[:]) == "XMAS" {
				c += 1
			}
		}
	}

	// verticaly up
	for i := len(lines) - 1; i >= 3; i -= 1 {
		for j := 0; j < len(lines[i]); j += 1 {
			buf: [4]u8 = {}
			buf[0] = lines[i][j]
			buf[1] = lines[i - 1][j]
			buf[2] = lines[i - 2][j]
			buf[3] = lines[i - 3][j]
			if string(buf[:]) == "XMAS" {
				c += 1
			}
		}
	}


	// down right
	for i := 0; i < len(lines) - 4; i += 1 {
		for j := 0; j < len(lines[i]) - 3; j += 1 {
			buf: [4]u8 = {}
			buf[0] = lines[i][j]
			buf[1] = lines[i + 1][j + 1]
			buf[2] = lines[i + 2][j + 2]
			buf[3] = lines[i + 3][j + 3]
			if string(buf[:]) == "XMAS" {
				c += 1
			}
		}
	}

	// down left
	for i := 0; i < len(lines) - 4; i += 1 {
		for j := 3; j < len(lines[i]); j += 1 {
			buf: [4]u8 = {}
			buf[0] = lines[i][j]
			buf[1] = lines[i + 1][j - 1]
			buf[2] = lines[i + 2][j - 2]
			buf[3] = lines[i + 3][j - 3]
			if string(buf[:]) == "XMAS" {
				c += 1
			}
		}
	}

	// up right
	for i := 3; i < len(lines); i += 1 {
		for j := 0; j < len(lines[i]) - 3; j += 1 {
			buf: [4]u8 = {}
			buf[0] = lines[i][j]
			buf[1] = lines[i - 1][j + 1]
			buf[2] = lines[i - 2][j + 2]
			buf[3] = lines[i - 3][j + 3]
			if string(buf[:]) == "XMAS" {
				c += 1
			}
		}
	}

	// up left
	for i := 3; i < len(lines); i += 1 {
		for j := 3; j < len(lines[i]); j += 1 {
			buf: [4]u8 = {}
			buf[0] = lines[i][j]
			buf[1] = lines[i - 1][j - 1]
			buf[2] = lines[i - 2][j - 2]
			buf[3] = lines[i - 3][j - 3]
			if string(buf[:]) == "XMAS" {
				c += 1
			}
		}
	}

	fmt.println(c)
}

check :: proc(sq: [3]string) -> bool {
	str1 := string([]u8{sq[0][0], sq[1][1], sq[2][2]})
	str2 := string([]u8{sq[0][2], sq[1][1], sq[2][0]})

	return (str1 == "MAS" || str1 == "SAM") && (str2 == "MAS" || str2 == "SAM")
}

second :: proc(lines: []string) {
	c := 0
	for i := 3; i <= len(lines); i += 1 {
		for j := 3; j <= len(lines[i - 1]); j += 1 {
			sq: [3]string = {lines[i - 3][j - 3:j], lines[i - 2][j - 3:j], lines[i - 1][j - 3:j]}
			if check(sq) {
				c += 1
			}
		}
	}

	fmt.println("second is: ", c)
}

main :: proc() {
	buf, err := os.read_entire_file_from_filename_or_err("./inputs/4_in.txt")
	if err != nil {
		fmt.println("can't read file: ", err)
		os.exit(1)
	}

	str: string = string(buf)
	lines := strings.split(str, "\n")
	defer delete(lines)

	first(lines)
	second(lines)
}
