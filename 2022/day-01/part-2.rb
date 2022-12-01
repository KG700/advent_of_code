require_relative '../helper'
include Helper

data = Helper::upload("2022/day-01/input.txt")
data_test = Helper::upload("2022/day-01/input-test.txt")

def calculate data
    max_elf = 0
    elves = []
    elf = []
    data.each do |calorie|
        if (calorie.empty?)
            elves.push(elf.sum)
            elf = []
        else
            elf.push(calorie.to_i)
        end
    end
    elves.push(elf.sum)

    sorted_elves = elves.sort.reverse
    p sorted_elves[0..2].sum
end

calculate data