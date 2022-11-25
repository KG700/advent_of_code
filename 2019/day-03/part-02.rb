require_relative '../helper'
include Helper

wires_data = Helper::upload("2019/day-03/input.txt")
wires_data_test_1 = Helper::upload("2019/day-03/input-test-1.txt")
wires_data_test_2 = Helper::upload("2019/day-03/input-test-2.txt")
wires_data_test_3 = Helper::upload("2019/day-03/input-test-3.txt")

def find_intersection wires
    wires = wires.map { |wire| wire.split(",")}
    
    first_wire = get_paths(wires[0])
    second_wire = get_paths(wires[1])

    first_wire_steps = 0
    second_wire_steps = 0

    min_steps = Float::INFINITY

    first_wire.each do |first_wire_path|
        
        second_wire_steps = 0
        second_wire.each do |second_wire_path|
            x_overlap = check_for_overlap(first_wire_path[0], second_wire_path[0])
            y_overlap = check_for_overlap(first_wire_path[1], second_wire_path[1])
            not_origin = x_overlap != 0 && y_overlap != 0
            if x_overlap && y_overlap && not_origin
                first_wire_next_steps = get_final_steps(first_wire_path, x_overlap, y_overlap)
                second_wire_next_steps = get_final_steps(second_wire_path, x_overlap, y_overlap)
                steps = first_wire_steps + second_wire_steps + first_wire_next_steps + second_wire_next_steps
                min_steps = [min_steps, steps].min
            end
            second_wire_steps += get_steps(second_wire_path)
        end
        first_wire_steps += get_steps(first_wire_path)
    end

    p min_steps
    
end

def get_final_steps path, x, y
    steps = 0
    case path.last
        when "R"
            steps += (x - path[0].begin).abs
        when "L"
            steps += (path[0].end - x).abs
        when "U"
            steps += (y - path[1].begin).abs
        when "D"
            steps += (path[1].end - y).abs
        else
            throw "Error"
    end
    steps
end

def get_steps path
    x_steps = (path[0].end - path[0].begin).abs
    y_steps = (path[1].end - path[1].begin).abs
    x_steps + y_steps
end

def get_paths wire
    wire_paths = []
    x = 0
    y = 0

    wire.each do |path|
        to_path = path[1..-1].to_i
        case path[0]
            when "R"
                wire_paths.push([(x..(x + to_path)), (y..y), "R"])
                x = x + to_path
            when "L"
                wire_paths.push([((x - to_path)..x), (y..y), "L"])
                x = x - to_path
            when "U"
                wire_paths.push([(x..x), (y..(y + to_path)), "U"])
                y = y + to_path
            when "D"
                wire_paths.push([(x..x), ((y - to_path)..y), "D"])
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