require_relative '../helper'
include Helper

data = Helper::upload("2023/day-09/input.txt")
data_test = Helper::upload("2023/day-09/input-test.txt")

def calculate data
   data = data.map { |sequence| sequence.split(" ").map(&:to_i) }

   sum_of_next_values = data.reduce(0) do |sum, sequence|
      sum + get_next_value(sequence)
   end

   sum_of_next_values
end

def get_next_value sequence
   all_zeros = true
   sequence.each do |value|
      all_zeros = value == 0 && all_zeros
   end
   return 0 if all_zeros

   differences = []
   sequence.each_with_index do |value, index|
      differences << value - sequence[index - 1] if index > 0
   end

   next_value = get_next_value differences

   sequence.first - next_value
end

p calculate data