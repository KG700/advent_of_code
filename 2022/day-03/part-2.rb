require 'set'
require_relative '../helper'
include Helper

data = Helper::upload("2022/day-03/input.txt")
data_test = Helper::upload("2022/day-03/input-test.txt")

def calculate data
    sum_of_priorities = 0
    data.each_slice(3) do |items|
        items = items.map { |item| item.split("").to_set }
        badge = items[0] & items[1] & items[2]
        sum_of_priorities += get_priority badge.to_a[0]
    end
    p sum_of_priorities
end

def get_priority letter
    adjustment = letter == letter.downcase ? 96 : 38
    letter.ord - adjustment
end

calculate data