package main

import utils "aoc_2024:utils"

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:text/regex"

first :: proc(rules: map[string][dynamic]string, all_pages: [dynamic][]string) {
	c := 0

	for line_of_pages in all_pages {
		flag := true
		for i := 0; i < len(line_of_pages); i += 1 {
			current_page := line_of_pages[i]
			if !flag {
				break
			}
			for j := 0; j < i; j += 1 {
				if !flag {
					break
				}

				prev_page := line_of_pages[j]
				next_pages, ok := rules[current_page]
				if !ok {
					continue
				}
				for next_page in next_pages {
					if prev_page == next_page {
						flag = false
						break
					}
				}
			}
		}
		c += flag ? strconv.atoi(line_of_pages[len(line_of_pages) / 2]) : 0
	}

	fmt.println("first is: ", c)
}

second :: proc(rules: map[string][dynamic]string, all_pages: [dynamic][]string) {
	c := 0

	broken := false
	for line_of_pages_idx := 0; line_of_pages_idx < len(all_pages); line_of_pages_idx += 1 {
		line_of_pages := all_pages[line_of_pages_idx]
		sw := -1
		sw2 := -1
		for current_page_idx := 0; current_page_idx < len(line_of_pages); current_page_idx += 1 {
			current_page := line_of_pages[current_page_idx]
			if sw != -1 {
				break
			}
			for prev_page_idx := 0; prev_page_idx < current_page_idx; prev_page_idx += 1 {
				if sw != -1 {
					break
				}

				prev_page := line_of_pages[prev_page_idx]
				next_pages, ok := rules[current_page]
				if !ok {
					continue
				}
				for next_page, n in next_pages {
					if prev_page == next_page {
						//						fmt.println("broken rule:", current_page, rules[current_page], prev_page)
						sw = prev_page_idx
						sw2 = current_page_idx
						break
					}
				}
			}
		}

		if sw != -1 {
			all_pages[line_of_pages_idx][sw], all_pages[line_of_pages_idx][sw2] =
				all_pages[line_of_pages_idx][sw2], all_pages[line_of_pages_idx][sw]
			//			fmt.println(
			//				line_of_pages_idx,
			//				all_pages[line_of_pages_idx][sw],
			//				all_pages[line_of_pages_idx][sw2],
			//			)
			broken = true
			line_of_pages_idx -= 1
			continue
		}
		if broken {
			fmt.println(all_pages[line_of_pages_idx])
		}
		c +=
			broken ? strconv.atoi(all_pages[line_of_pages_idx][len(all_pages[line_of_pages_idx]) / 2]) : 0

		broken = false
	}

	fmt.println("second is: ", c)
}


main :: proc() {
	buf, err := os.read_entire_file_from_filename_or_err("./inputs/5_in.txt")
	if err != nil {
		fmt.println("can't read file: ", err)
		os.exit(1)
	}
	defer delete(buf)

	parts := strings.split(string(buf), "\n\n")
	defer delete(parts)

	rules_str := parts[0]
	pagesStr := parts[1]

	rules_lines := strings.split(rules_str, "\n")

	rules := make(map[string][dynamic]string)
	defer delete(rules)
	defer {
		for _, v in rules {
			delete(v)
		}
	}
	for i := 0; i < len(rules_lines); i += 1 {
		kv_rules := strings.split(rules_lines[i], "|")
		defer delete(kv_rules)

		val, ok := rules[kv_rules[0]]
		if !ok {
			val: [dynamic]string = {kv_rules[1]}
			rules[kv_rules[0]] = val
		} else {
			append(&val, kv_rules[1])
			rules[kv_rules[0]] = val
		}
	}

	pages_lines := strings.split(pagesStr, "\n")
	defer delete(pages_lines)

	pages_arr: [dynamic][]string = {}
	defer delete(pages_arr)
	for v in pages_lines {
		if v == "" {
			continue
		}
		values := strings.split(v, ",")
		append(&pages_arr, values)
	}

	//	fmt.println(rules)
	//    fmt.println(pages)

	first(rules, pages_arr)
	second(rules, pages_arr)
}
