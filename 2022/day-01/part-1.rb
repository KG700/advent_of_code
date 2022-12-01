require_relative '../helper'
include Helper

data = Helper::upload("2022/day-01/input.txt")
data_test = Helper::upload("2022/day-01/input-test.txt")

def calculate data
    max_elf = 0
    elf = 0
    data.each do |calories|
        elf += calories.empty? ? 0 : calories.to_i
        max_elf = [elf, max_elf].max if calories.empty?
        elf = 0  if calories.empty?
    end
    max_elf = [elf, max_elf].max
    p max_elf
end

calculate data