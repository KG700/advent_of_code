require_relative '../helper'
include Helper

lava_data = Helper::upload("2021/day-09/part-1-input.txt")
lava_test_data = Helper::upload("2021/day-09/test-input.txt")

def total_risk_level lava_data
    
    lava_data = lava_data.map { |cave| cave.split("") }
    
    points_with_adjacents = []
    lava_data.each_with_index.map do |row, y_index|
        row.each_with_index do |point, x_index|
            adjacent_points = []
            adjacent_points.push(row[x_index + 1].to_i) if x_index + 1 < row.length
            adjacent_points.push(lava_data[y_index + 1][x_index].to_i) if y_index + 1 < lava_data.length
            adjacent_points.push(lava_data[y_index][x_index - 1].to_i) if x_index - 1 >= 0
            adjacent_points.push(lava_data[y_index - 1][x_index].to_i) if y_index - 1 >= 0
            risk_point = point.to_i < adjacent_points.min
            points_with_adjacents.push({:point => point.to_i, :adjacent => adjacent_points, :risk => risk_point})
        end
    end

    high_risk_points = points_with_adjacents.select {|point| point[:risk]}
    risk_level = high_risk_points.reduce(0) {|sum, point| sum + point[:point] + 1}
    p risk_level

end

total_risk_level lava_data