require_relative '../helper'
include Helper

data = Helper::upload("2023/day-15/input.txt")
data_test_1 = Helper::upload("2023/day-15/input-test-1.txt")
data_test_2 = Helper::upload("2023/day-15/input-test-2.txt")

def calculate data
   input_strings = data[0].split(",")

   hash_number = input_strings.reduce(0) do |sum, input_string|
      number = 0
      input_string.chars.each do |char|
         number = (number + char.ord) * 17 % 256
      end
      sum + number
   end

   hash_number
end

p calculate data