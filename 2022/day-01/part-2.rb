require_relative '../helper'
include Helper

data = Helper::upload_line_break("2022/day-01/input.txt")
data_test = Helper::upload_line_break("2022/day-01/input-test.txt")

def calculate data
    data.map! { |elf| elf.split("\n").map(&:to_i) }
    elves = data.reduce([]) { |elves, elf| elves.push(elf.sum) }
    p elves.sort.reverse[0..2].sum
end

calculate data