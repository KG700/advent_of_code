
require_relative '../helper'
include Helper

def continuous_numbers(data, failing_number)
    range_start = 0
    range_end = 0
    data.each_with_index do |p, x|
        range_start = x
        running_sum = data[x]
        range_found = false
        ((x + 1)..data.length).each_with_index do |num, index| 
            running_sum += data[num]
            break if running_sum > failing_number
            if running_sum == failing_number
                range_end = range_start + index + 1
                range_found = true
                break
            end
        end
        break if range_found
    end
    p data[range_start...range_end].min + data[range_start...range_end].max
end

def failing_number(data, trail_number)
    xmas_number = nil

    ((trail_number + 1)...data.length).each do |x|
        xmas_number = x
        first_trail = xmas_number - trail_number
        trail = data[first_trail...xmas_number]
        in_trail = false
        trail.each_with_index do |num, index| 
            ((index + 1)...trail_number).each do |n|
                if num + trail[n] == data[xmas_number]
                    in_trail = true
                    break
                end
            end
            break if in_trail
        end
        break if !in_trail
    end
    data[xmas_number]
end

# TEST_DATA = [35 ,20 ,15 ,25 ,47 ,40 ,62 ,55 ,65 ,95 ,102 ,117 ,150 ,182 ,127 ,219 ,299 ,277 ,309 ,576]
xmas_data = Helper::upload("day-9/XMAS-data.txt").map(&:to_i)
number = failing_number(xmas_data, 25)
continuous_numbers(xmas_data, number)