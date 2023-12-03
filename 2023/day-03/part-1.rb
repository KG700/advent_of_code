require_relative '../helper'
include Helper

data = Helper::upload("2023/day-03/input.txt")
data_test = Helper::upload("2023/day-03/input-test.txt")

def calculate data

    coords = Hash.new {|h,k| h[k] = [] }
    part_positions = {}
    symbol_positions = []
    current_part_number = ''

    data.each_with_index do |row, row_number|
        row.split("").each_with_index do |char, col_number|
            is_column_end = col_number === data[0].length - 1

            if !char.match?(/[[:digit:]]/) && char != "."
                symbol_positions.push("#{row_number},#{col_number}") 
            end

            if !char.match?(/[[:digit:]]/) && current_part_number.length > 0
                part_position = "#{row_number},#{col_number - current_part_number.length}"
                part_positions[part_position] = current_part_number.to_i
                coordinates = get_coordinates(row_number, col_number, current_part_number.length)
                coordinates.each { |coord| coords[coord].push(part_position) if !coords[coord].include? part_position }
                current_part_number = ''
            end

            if is_column_end && char.match?(/[[:digit:]]/)
                current_part_number += char
                part_position = "#{row_number},#{col_number - current_part_number.length + 1}"
                part_positions[part_position] = current_part_number.to_i
                coordinates = get_coordinates(row_number, col_number + 1, current_part_number.length)
                coordinates.each { |coord| coords[coord].push(part_position) if !coords[coord].include? part_position }
                current_part_number = ''
            end

            next if !char.match?(/[[:digit:]]/) || is_column_end

            current_part_number += char
        end
    end

    symbol_positions.reduce(0) do |total, position|
        total + coords[position].reduce(0) do |total, position| 
            total + part_positions[position]
        end
    end
end

def get_coordinates(row, col, width)
    coords = []

    (0...width + 2).each do |n|
        coords.push("#{row - 1},#{col - n}")
        coords.push("#{row + 1},#{col - n}")
    end

    coords.push("#{row},#{col - width - 1}")
    coords.push("#{row},#{col}")
end

p calculate data