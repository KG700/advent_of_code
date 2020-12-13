require_relative '../helper'
include Helper

test_numbers = ["939","7,13,x,x,59,x,31,19"]
bus_numbers = Helper::upload("day-13/bus-data.txt")
# p bus_numbers

def next_bus buses
    time_stamp = buses[0].to_i
    next_buses = buses[1].split(",").select! { |bus| bus != 'x'}.map(&:to_i)
    minutes_to_next = []
    next_buses.each do |bus| 
            minutes_to_next.push({
                "bus" => bus,
                "minutes" => bus - time_stamp % bus
            })
    end
    next_bus = minutes_to_next.min_by { |bus| bus["minutes"] }
    p next_bus["bus"] * next_bus["minutes"]
end

next_bus bus_numbers