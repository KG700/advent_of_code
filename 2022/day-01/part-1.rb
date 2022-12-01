require_relative '../helper'
include Helper

data = Helper::upload("2022/day-01/input.txt")
data_test = Helper::upload("2022/day-01/input-test.txt")

def calculate data
    max_elf = 0
    elf = []
    data.each do |calorie|
        if (calorie.empty?)
            max_elf = [elf.sum, max_elf].max
            elf = []
        else
            elf.push(calorie.to_i)
        end
    end
    max_elf = [elf.sum, max_elf].max
    p max_elf
end

calculate data