require 'set'
require_relative '../helper'
include Helper

lava_data = Helper::upload("day-09/part-1-input.txt").map { |cave| cave.split("") }
lava_test_data = Helper::upload("day-09/test-input.txt").map { |cave| cave.split("") }

def total_risk_level data

    points_with_adjacents = []
    data.each_with_index do |row, y_index|
        row.each_with_index do |point, x_index|
            adjacent_points = []
            adjacent_points.push(row[x_index + 1].to_i) if x_index + 1 < row.length
            adjacent_points.push(data[y_index + 1][x_index].to_i) if y_index + 1 < data.length
            adjacent_points.push(data[y_index][x_index - 1].to_i) if x_index - 1 >= 0
            adjacent_points.push(data[y_index - 1][x_index].to_i) if y_index - 1 >= 0
            low_point = point.to_i < adjacent_points.min
            points_with_adjacents.push({:point => point.to_i, :coords => [y_index, x_index], :low => low_point})
        end
    end

    low_points = points_with_adjacents.select {|point| point[:low]}
    basin_sets = low_points.map { |low_point| find_basin_size(low_point, data)}
    basin_sizes = basin_sets.to_a.map {|basin| basin.length}
    basins_sorted = basin_sizes.sort.reverse
    p basins_sorted[0] * basins_sorted[1] * basins_sorted[2]

end

def find_basin_size point, data
    
            y_index = point[:coords][0]
            x_index = point[:coords][1]

            basins_set = Set[]
            basins_set.add("#{y_index},#{x_index}")

            right_point = x_index + 1 < data[0].length ? data[y_index][x_index + 1].to_i : nil
            bottom_point = y_index + 1 < data.length ? data[y_index + 1][x_index].to_i : nil
            left_point = x_index - 1 >= 0 ? data[y_index][x_index - 1].to_i : nil
            top_point = y_index - 1 >= 0 ? data[y_index - 1][x_index].to_i : nil

            if right_point && right_point > point[:point] && right_point != 9
                right_point_details = {:point => right_point, :coords => [y_index, x_index + 1]}
                basins_set.merge(find_basin_size(right_point_details, data))
            end

            if bottom_point && bottom_point > point[:point] && bottom_point != 9
                bottom_point_details = {:point => bottom_point, :coords => [y_index + 1, x_index]}
                basins_set.merge(find_basin_size(bottom_point_details, data))
            end

            if left_point && left_point > point[:point] && left_point != 9
                left_point_details = {:point => left_point, :coords => [y_index, x_index - 1]}
                basins_set.merge(find_basin_size(left_point_details, data))
            end

            if top_point && top_point > point[:point] && top_point != 9
                top_point_details = {:point => top_point, :coords => [y_index - 1, x_index]}
                basins_set.merge(find_basin_size(top_point_details, data))
            end

            basins_set
end

total_risk_level lava_data