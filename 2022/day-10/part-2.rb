require_relative '../helper'
include Helper

data = Helper::upload("2022/day-10/input.txt")
data_test = Helper::upload("2022/day-10/input-test.txt")

def calculate instructions
    x = 1
    cycle = 0
    image = []
    image_line = ''

    instructions.each_with_index do |instruction, index|
        ins, v = instruction.split(" ")
        cycle, x, image_line, image = run_circuit(cycle, x, image_line, image)
        
        next if ins == "noop"
        cycle, x, image_line, image = run_circuit(cycle, x, image_line, image)
        x += v.to_i

    end

    image.each { |line| p line }

end

def run_circuit cycle, x, image_line, image
    cycle += 1
    position = (cycle - 1) % 40
    image_line += [x - 1, x, x + 1].include?(position) ? '#' : '.'

    if position == 39
        image.push(image_line)
        image_line = ''
    end
    [cycle, x, image_line, image]
end

calculate data