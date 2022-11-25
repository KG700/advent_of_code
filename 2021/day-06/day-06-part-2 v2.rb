## This version is inspired by someone's solution I found online and not completely my own work

require_relative '../helper'
include Helper

fish_data = Helper::upload("day-06/part-1-input.txt")
# fish_test_data = Helper::upload("day-06/test-input.txt")

def simulate_fish_population fish_data, days
    fish_data = fish_data[0].split(",").map(&:to_i)
    fish_hash = Hash.new(0)

    fish_data.each  { |fish| fish_hash[fish] += 1 }

    days.times do |day|
        new_fish_hash = Hash.new(0)
        fish_hash.each do |fish_type, num|
            if fish_type === 0
                new_fish_hash[6] += num
                new_fish_hash[8] += num
            else
                new_fish_hash[fish_type - 1] += num
            end
        end
        fish_hash = new_fish_hash
    end

    fish_count = 0
    fish_hash.each {|fish, num| fish_count += num}
    p fish_count

end

simulate_fish_population fish_data, 256