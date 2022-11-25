require_relative '../helper'
include Helper

crab_data = Helper::upload("day-07/part-1-input.txt")
# crab_test_data = Helper::upload("day-07/test-input.txt")

def optimal_position crab_data
    crab_data = crab_data[0].split(",").map(&:to_i)
    fuel_consumed_for_steps = Hash.new(0)
    (crab_data.min..crab_data.max).reduce(0) do |sum, step| 
        fuel_consumed_for_steps[step] = sum + step
        sum + step
    end

    min_fuel = nil
    min_fuel_position = nil
    (crab_data.min...crab_data.max).each do |num| 
        fuel_consumed = crab_data.reduce(0) do |sum, pos|
            sum + fuel_consumed_for_steps[(num - pos).abs] 
        end
        is_minimum = !min_fuel || fuel_consumed < min_fuel
        min_fuel = fuel_consumed if is_minimum
        min_fuel_position = num if is_minimum
    end
    
    p min_fuel_position
    p min_fuel

end

optimal_position crab_data