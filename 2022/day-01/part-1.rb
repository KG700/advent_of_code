require_relative '../helper'
include Helper

data = Helper::upload_line_break("2022/day-01/input.txt")
data_test = Helper::upload_line_break("2022/day-01/input-test.txt")

def calculate data
    data.map! { |elf| elf.split("\n").map(&:to_i) }
    max_elf = data.reduce(0) { |max_elf, elf| [max_elf, elf.sum].max }      
    p max_elf
end

calculate data