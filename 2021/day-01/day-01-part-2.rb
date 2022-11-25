require_relative '../helper'
include Helper

depth_data = Helper::upload("2021/day-01/part-1-input.txt")

def calculate_increase_rate depth_data
    
    depth_data.map! { |data| data.to_i}

    direction = []
    depth_comparison = depth_data[0] + depth_data[1] + depth_data[2]

    depth_data.each_with_index do |data, index|
        next if index <= 2

        depth_sum = data + depth_data[index - 1] + depth_data[index - 2]

        if depth_sum > depth_comparison
            direction.push("increase")
        else
            direction.push("decrease")
        end
        depth_comparison = depth_sum
    end
    
    p direction.count("increase")

end

calculate_increase_rate depth_data