package utils

import "core:os"
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
Vector5 :: distinct [5]int

read_file_lines :: proc(filename: string) -> (lines: []string, err: Error) {
	buf := os.read_entire_file_from_filename_or_err(filename) or_return

	str: string = string(buf)
	lines = strings.split(str, "\n")

	return lines, .None
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
