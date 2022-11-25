require_relative '../helper'
include Helper

instructions_data = Helper::upload("2021/day-02/part-1-input.txt")

def calculate_position instructions_data
    
    instructions_data.map! { |data| data.split(" ")}
    
    # p instructions_data

    position = [0,0]
    instructions_data.each do |data|
        case data[0]
        when "forward"
            position[1] += data[1].to_i
        when "down"
            position[0] += data[1].to_i
        when "up"
            position[0] -= data[1].to_i
        else
            p "something else given"
        end
    end

    p position
    p position[0] * position[1]

end

calculate_position instructions_data