require_relative '../helper'
include Helper

data = Helper::upload("2023/day-01/input.txt")
data_test = Helper::upload("2023/day-01/input-test.txt")

def calculate data
    data.reduce(0) { |total, code| total + "#{code.delete("^0-9")[0]}#{code.delete("^0-9")[-1]}".to_i }
end

p calculate data