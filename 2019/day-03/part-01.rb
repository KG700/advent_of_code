require_relative '../helper'
include Helper

wires_data = Helper::upload("2019/day-03/input.txt")
wires_data_test = Helper::upload("2019/day-03/input-test-1.txt")

def find_intersection wires
    wires = wires.map { |wire| wire.split(",")}
    
    first_wire = get_paths(wires[0])
    second_wire = get_paths(wires[1])

    min_distance = Float::INFINITY

    first_wire.each do |first_wire_path|
        second_wire.each do |second_wire_path|
            x_overlap = check_for_overlap(first_wire_path[0], second_wire_path[0])
            y_overlap = check_for_overlap(first_wire_path[1], second_wire_path[1])
            not_origin = x_overlap != 0 && y_overlap != 0
            if x_overlap && y_overlap && not_origin
                distance = x_overlap.abs + y_overlap.abs
                min_distance = [distance, min_distance].min
            end
        end
    end

    p min_distance
    
end

def get_paths wire
    wire_paths = []
    x = 0
    y = 0

    wire.each do |path|
        to_path = path[1..-1].to_i
        case path[0]
            when "R"
                wire_paths.push([(x..(x + to_path)), (y..y)])
                x = x + to_path
            when "L"
                wire_paths.push([((x - to_path)..x), (y..y)])
                x = x - to_path
            when "U"
                wire_paths.push([(x..x), (y..(y + to_path))])
                y = y + to_path
            when "D"
                wire_paths.push([(x..x), ((y - to_path)..y)])
                y = y - to_path
            else
                throw "Error"
        end
    end
    wire_paths
end

def check_for_overlap range_1, range_2
    overlap = nil
    overlap = range_1.begin if range_2.include? range_1.begin
    overlap = range_2.begin if range_1.include? range_2.begin
    overlap
end

find_intersection wires_data