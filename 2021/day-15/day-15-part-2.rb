require "set"
require_relative '../helper'
include Helper

cave_data = Helper::upload("day-15/part-1-input.txt")
cave_data_test = Helper::upload("day-15/test-input.txt")

def shortest_path cave_data
    cave_data.map! {|cave| cave.split("")}
    new_cave_data = Array.new(cave_data.length * 5) { |i| Array.new(cave_data[0].length * 5) }
    new_cave_data = new_cave_data.each_with_index.map do |row, row_index|
        cave_section_row = (row_index - row_index % cave_data.length) / cave_data.length
        row.each_with_index.map do |col, col_index|
            cave_section_col = (col_index - col_index % cave_data[0].length) / cave_data[0].length
            (cave_data[row_index % cave_data.length][col_index % cave_data[0].length].to_i + cave_section_row + cave_section_col - 1) % 9 + 1
        end
    end

    first_cave = "0,0"
    last_cave = "#{new_cave_data.length - 1},#{new_cave_data[0].length - 1}"
    cave_graph = {}
    cave_costs = Hash.new(Float::INFINITY)
    new_cave_data.each_with_index do |row, row_index|
        row.each_with_index do |col, col_index|
            neighbours = find_neighbours(row_index, col_index, new_cave_data.length, row.length)
            neighbours_hash = {}
            neighbours.each do |neighbour| 
                neighbour_cost = new_cave_data[neighbour[0]][neighbour[1]]
                neighbours_hash["#{neighbour[0]},#{neighbour[1]}"] = neighbour_cost.to_i
            end
            cave_graph["#{row_index},#{col_index}"] = neighbours_hash
        end
    end

    cave_graph[first_cave].each do |cave, cost| 
        cave_costs[cave] = cost
    end

    processed = Set[]
    processed.add(first_cave)
    
    number_of_loops = new_cave_data.length * new_cave_data[0].length - 2
    number_of_loops.times do |n|
        next_cave = find_nearest_unprocessed_cave(cave_costs, processed, last_cave)
        next_cave_cost = cave_costs[next_cave]
        cave_graph[next_cave].each do |cave, cost|
            new_cost = cost + next_cave_cost
            if !processed.include?(cave) && new_cost < cave_costs[cave]
                cave_costs[cave] = new_cost
            end
        end
        processed.add(next_cave)
        cave_costs.delete(next_cave)
    end
    p cave_costs[last_cave]

end

def find_neighbours( row, col, max_row, max_col )
    neighbours = []
    neighbours.push([row + 1, col]) if row + 1 < max_row
    neighbours.push([row, col + 1]) if col + 1 < max_col
    neighbours.push([row - 1, col]) if row - 1 >= 0
    neighbours.push([row, col - 1]) if col - 1 >= 0
    neighbours
end

def find_nearest_unprocessed_cave(costs, processed, last_cave)
    node = ""
    min_cost = Float::INFINITY
    costs.each do |cave, cost|
        next if processed.include? cave
        next if cave === last_cave
        if min_cost > cost
            min_cost = cost
            node = cave
        end
    end
    node
end

shortest_path cave_data