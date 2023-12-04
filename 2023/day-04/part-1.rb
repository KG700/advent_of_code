require_relative '../helper'
include Helper

data = Helper::upload("2023/day-04/input.txt")
data_test = Helper::upload("2023/day-04/input-test.txt")

def calculate data
    data.reduce(0) do |points, card|
        card, numbers = card.split(": ")
        winning_numbers, my_numbers = numbers.split(" | ")
        matching_numbers = winning_numbers.split(" ").reduce(0) { |count, number| count + (my_numbers.split(" ").include?(number) ? 1 : 0) }
        points + (matching_numbers > 0 ? 2**(matching_numbers - 1) : 0)
    end
end

p calculate data