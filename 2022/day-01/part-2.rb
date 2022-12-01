require_relative '../helper'
include Helper

data = Helper::upload("2022/day-01/input.txt")
data_test = Helper::upload("2022/day-01/input-test.txt")

def calculate data
    elves = []
    elf = 0
    data.each do |calories|
        elf += calories.empty? ? 0 : calories.to_i
        elves.push(elf) if calories.empty?
        elf = 0  if calories.empty?
    end
    elves.push(elf)
    p elves.sort.reverse[0..2].sum
end

calculate data