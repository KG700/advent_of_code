require_relative '../helper'
include Helper

def multiplied_trees
    trees = travel_route(1, 1) * travel_route(3, 1) * travel_route(5, 1) * travel_route(7, 1) * travel_route(1, 2)
    p trees
end

def travel_route(right, down)
    the_map = Helper::upload("2020/day-03/part-1-map.txt")
    x_pos = 0
    tree_count = 0
    the_map.each_with_index.map do |row, index|
        if index % down == 0 
            if row[x_pos] == "#"
                row[x_pos] = "X"
                tree_count += 1
            else
                row[x_pos] = "O"
            end
            x_pos += right
            x_pos = x_pos % row.length
        end
    end
    tree_count
end

multiplied_trees