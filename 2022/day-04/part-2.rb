require_relative '../helper'
include Helper

data = Helper::upload("2022/day-04/input.txt")
data_test = Helper::upload("2022/day-04/input-test.txt")

def calculate data
    data.map! {|elves| elves.split(",") }
    count = data.reduce(0) { |count, elves| count += overlap?(elves) ? 1 : 0 }
    p count
end

def overlap? ranges
    elves = ranges.map { |elf| elf.split("-").map(&:to_i) }
    elf_1, elf_2 = elves

    overlap_1 = elf_2[0] >= elf_1[0] && elf_2[0] <= elf_1[1]
    overlap_2 = elf_1[0] >= elf_2[0] && elf_1[0] <= elf_2[1]
    overlap_1 || overlap_2
end

calculate data