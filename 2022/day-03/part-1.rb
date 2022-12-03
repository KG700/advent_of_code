require_relative '../helper'
include Helper

data = Helper::upload("2022/day-03/input.txt")
data_test = Helper::upload("2022/day-03/input-test.txt")

def calculate data
    sum_of_priorities = data.reduce(0) do |sum, items|
        half = items.length / 2
        first_compartment = items[0...half].split("")
        second_compartment = items[half..-1].split("")
        common_item = first_compartment & second_compartment
        sum += get_priority common_item[0]
    end
    p sum_of_priorities
end

def get_priority letter
    adjustment = letter == letter.downcase ? 96 : 38
    letter.ord - adjustment
end

calculate data