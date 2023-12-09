require_relative '../helper'
include Helper

data = Helper::upload_line_break("2023/day-08/input.txt")
data_test_3 = Helper::upload_line_break("2023/day-08/input-test-3.txt")
data_test_4 = Helper::upload_line_break("2023/day-08/input-test-4.txt")

LOOPS = 50000

def calculate data
    elements_map = {}
    elements_instructions_map = {}
    instructions, elements = data
    instruction_length = instructions.length
    elements = elements.split(")\n").map { |element| element.split(" = (") }
    elements.each { |element| elements_map[element[0]] = element[1] }
    starting_elements = elements.select { |element| element[0][-1] == 'A' }.map { |element| element[0] }

    elements.each do |element|
        next_element = element[0]
        elements_instructions_map[element[0]] = { :zs => [], :next => '' }

        instructions.chars.each_with_index do |instruction, index|
            next_element = instruction == 'L' ? elements_map[next_element][0..2] : elements_map[next_element][5..7]
            elements_instructions_map[element[0]][:zs] << index + 1 if next_element[-1] == 'Z'
        end

        elements_instructions_map[element[0]][:next] = next_element
    end

    copy = deep_copy(elements_instructions_map)
    LOOPS.times do |n|
        copy.each do |element, instructions|
            next_element = elements_instructions_map[element][:next]
            zs = copy[next_element][:zs].map { |z| z + instruction_length * (n + 1) }
            elements_instructions_map[element][:zs].concat(zs)
            elements_instructions_map[element][:next] = copy[next_element][:next]
        end
    end

    instruction_length *= (LOOPS + 1)

    journey = {}
    starting_elements.each do |element|
        journey[element] = element
    end

    all_finished = []
    loop_index = 0
    loop do
        compare_zs = starting_elements.map do |element|
            zs = elements_instructions_map[journey[element]][:zs]
            zs.map { |z| z + instruction_length * loop_index }
        end

        all_finished = compare_zs.reduce(compare_zs[0]) { |overlap, element| overlap & element }
        
        break unless all_finished.empty?

        starting_elements.each do |element|
            next_element = journey[element]
            journey[element] = elements_instructions_map[next_element][:next]
        end
        
        loop_index += 1
    end
    
    all_finished[0]
end

p calculate data
