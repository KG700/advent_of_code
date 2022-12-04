require_relative '../helper'
include Helper

data = Helper::upload("2022/day-04/input.txt")
data_test = Helper::upload("2022/day-04/input-test.txt")

def calculate data
    data.map! {|elves| elves.split(",") }
    count = data.reduce(0) { |count, elves| count += fully_contains?(elves) ? 1 : 0 }
    p count
end

def fully_contains? ranges
    elves = ranges.map { |elf| elf.split("-").map(&:to_i) }
    elf_1, elf_2 = elves
    
    elf_1_contains_elf_2 = elf_2[0] >= elf_1[0] && elf_2[1] <= elf_1[1]
    elf_2_contains_elf_1 = elf_1[0] >= elf_2[0] && elf_1[1] <= elf_2[1]
    elf_1_contains_elf_2 || elf_2_contains_elf_1
end

calculate data