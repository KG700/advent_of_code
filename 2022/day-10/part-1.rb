require_relative '../helper'
include Helper

data = Helper::upload("2022/day-10/input.txt")
data_test = Helper::upload("2022/day-10/input-test.txt")

def calculate instructions
    x = 1
    cycle = 0
    sum = 0

    instructions.each_with_index do |instruction, index|
        ins, v = instruction.split(" ")
        cycle += 1

        sum += cycle * x if (cycle - 20) % 40 == 0
        next if ins == "noop"

        cycle += 1
        sum += cycle * x if (cycle - 20) % 40 == 0
        x += v.to_i
    end

    p sum

end

calculate data