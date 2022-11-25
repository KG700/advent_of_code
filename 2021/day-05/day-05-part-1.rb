require 'set'
require_relative '../helper'
include Helper

lines_data = Helper::upload("day-05/part-1-input.txt")
# lines_test_data = Helper::upload("day-05/test-input.txt")

def find_overlapping_lines lines_data

    lines = lines_data.map {|line| line.split(" -> ")}
    occupied_dimensions = lines.map { |line| create_line line }.flatten
    unique_dimensions = Set[]
    duplicate_dimensions = Set[]
    occupied_dimensions.each do |dim| 
        duplicate_dimensions.add(dim) if dim && unique_dimensions.include?(dim)
        unique_dimensions.add(dim) if dim
    end
    p duplicate_dimensions.length
end

def create_line dimensions
    start_point = dimensions[0].split(",").map(&:to_i)
    end_point = dimensions[1].split(",").map(&:to_i)

    if start_point[0] < end_point[0] && start_point[1] == end_point[1]
        move = [1,0]
    elsif start_point[0] > end_point[0] && start_point[1] == end_point[1]
        move = [-1,0]
    elsif start_point[1] < end_point[1] && start_point[0] == end_point[0]
        move = [0,1]
    elsif start_point[1] > end_point[1] && start_point[0] == end_point[0]
        move = [0,-1]
    else
        move = [0,0]
    end
    point_a = start_point
    if move.sum != 0
        lines_array = ["#{point_a[0]},#{point_a[1]}"]
        while point_a[0] != end_point[0] || point_a[1] != end_point[1]
            point_a[0] += move[0]
            point_a[1] += move[1]
            lines_array.push("#{point_a[0]},#{point_a[1]}")
        end
    end
    lines_array

end

find_overlapping_lines lines_data