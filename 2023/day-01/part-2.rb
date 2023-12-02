require_relative '../helper'
include Helper

data = Helper::upload("2023/day-01/input.txt")
data_test = Helper::upload("2023/day-01/input-test-2.txt")

def calculate data
    numbers_map = {'one' => 1, 'two' => 2, 'three' => 3, 'four' => 4, 'five' => 5, 'six' => 6, 'seven' => 7, 'eight' => 8, 'nine' => 9}
    data.reduce(0) do |total, code|
        numbers_map.each do |number, value| 
            code.sub! number, number.dup.insert(1, value.to_s)
            code.sub! number, number.dup.insert(1, value.to_s)
            code.sub! number, number.dup.insert(1, value.to_s)
        end
        total + "#{code.delete("^0-9")[0]}#{code.delete("^0-9")[-1]}".to_i
    end
end

p calculate data