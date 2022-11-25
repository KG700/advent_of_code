require_relative '../helper'
include Helper

depth_data = Helper::upload("2021/day-01/part-1-input.txt")

def calculate_increase_rate depth_data
    
    depth_data.map! { |data| data.to_i}

    direction = []
    depth_data.each_with_index do |data, index|
        next if index === 0
           
        if data > depth_data[index - 1]
            direction.push("increase")
        else
            direction.push("decrease")
        end
    end

    p direction.count("increase")

end

calculate_increase_rate depth_data