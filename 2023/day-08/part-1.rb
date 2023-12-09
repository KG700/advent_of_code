require_relative '../helper'
include Helper

data = Helper::upload_line_break("2023/day-08/input.txt")
data_test_1 = Helper::upload_line_break("2023/day-08/input-test-1.txt")
data_test_2 = Helper::upload_line_break("2023/day-08/input-test-2.txt")


def calculate data

    elements_map = {}
    instructions, elements = data
    elements = elements.split(")\n").map { |element| element.split(" = (") }
    elements.each { |element| elements_map[element[0]] = element[1] }

    current_element = "AAA"
    count = 0
    index = 0
    
    while current_element != "ZZZ"
        char = instructions[index]
        if char == "L"
            current_element = elements_map[current_element][0..2]
        else
            current_element = elements_map[current_element][5..7]
        end
        index = (index + 1) % instructions.length
        count += 1
    end

    count
end

p calculate data