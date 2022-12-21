require_relative '../helper'
include Helper

data = Helper::upload("2022/day-15/input.txt")
data_test = Helper::upload("2022/day-15/input-test.txt")

ROW = 10

class Sensor

    attr_reader :position, :nearest_beacon

    def initialize position, beacon_position
        @position = position
        @nearest_beacon = beacon_position
    end

    def distance_from_beacon
        (@position[0] - @nearest_beacon[0]).abs + (@position[1] - @nearest_beacon[1]).abs
    end

    def positions_not_containing_beacon y
        return nil if y < @position[1] - distance_from_beacon || y > @position[1] + distance_from_beacon
        start_of_range = @position[0] - distance_from_beacon + (y - @position[1]).abs
        end_of_range = @position[0] + distance_from_beacon - (y - @position[1]).abs

        if @nearest_beacon[1] == y
            start_of_range += 1 if @nearest_beacon[0] == start_of_range
            end_of_range -= 1 if @nearest_beacon[0] == end_of_range
        end
        return nil if start_of_range > end_of_range

        [start_of_range, end_of_range]
    end

end

def calculate data

    sensors = []

    data.each do |line|
        sensor, beacon = line.split(": ")
        sensor_position = sensor.split(",").map { |coord| coord.split("=") }.map { |coord| coord[1].to_i }
        beacon_position = beacon.split(",").map { |coord| coord.split("=") }.map { |coord| coord[1].to_i }
        sensors.push(Sensor.new(sensor_position, beacon_position))
    end

    ranges = []
    sensors.each do |sensor| 
        ranges = create_range(ranges,sensor.positions_not_containing_beacon(ROW))
    end

    positions_not_containing_beacon = ranges.reduce(0) { |sum, range| sum += (range[1] - range[0]) + 1 }
    p positions_not_containing_beacon

end

def create_range ranges, range_to_add

    return ranges if range_to_add.nil?
    return [range_to_add] if ranges.length == 0

    merged_ranges = []
    merge_range = []
    carry_over = nil

    ranges.each do |range|

        if carry_over.nil? || range_to_add[0] > carry_over + 1
            if range_to_add[0] > range[1] + 1
                merged_ranges.push(range)
            elsif range_to_add[1] < range[0]
                merged_ranges.push(range_to_add)
                merged_ranges.push(range)
            elsif range_to_add[1] <= range[1]
                merged_ranges.push([[range_to_add[0], range[0]].min, [range_to_add[1], range[1]].max])
            else
                merge_range.push([range_to_add[0], range[0]].min)
            end
        else
            if merge_range.length == 0
                merged_ranges.push(range)
            elsif range_to_add[1] < range[0]
                merge_range.push(range_to_add[1])
                merged_ranges.push(merge_range) 
                merged_ranges.push(range)
                merge_range = []
            elsif range_to_add[1] <= range[1]
                merge_range.push(range[1])
                merged_ranges.push(merge_range)
                merge_range = []
            end
        end
        carry_over = range[1]
    end

    if merge_range.length > 0
        merge_range.push([carry_over, range_to_add[1]].max)
        merged_ranges.push(merge_range)
        merge_range = []
    end

    if merged_ranges.last[1] < range_to_add[0]
        merged_ranges.push(range_to_add)
    end
    
    merged_ranges
end

calculate data_test