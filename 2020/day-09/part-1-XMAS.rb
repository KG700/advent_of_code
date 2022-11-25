
require_relative '../helper'
include Helper

def first_failing_number(data, trail_number)
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
    p data[xmas_number]
end

xmas_data = Helper::upload("2020/day-09/XMAS-data.txt").map(&:to_i)

# TEST_DATA = [35 ,20 ,15 ,25 ,47 ,40 ,62 ,55 ,65 ,95 ,102 ,117 ,150 ,182 ,127 ,219 ,299 ,277 ,309 ,576]
first_failing_number(xmas_data, 25)