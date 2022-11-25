require_relative '../helper'
include Helper

def travel_route
    the_map = Helper::upload("2020/day-03/part-1-map.txt")
    x_pos = 0
    tree_count = 0
    the_map.map do |row| 
        if row[x_pos] == "#"
            row[x_pos] = "X"
            tree_count += 1
        else
            row[x_pos] = "O"
        end
        x_pos += 3
        x_pos = x_pos % row.length
    end
    p tree_count
end

travel_route