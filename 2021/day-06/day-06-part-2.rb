require_relative '../helper'
include Helper

fish_data = Helper::upload("2021/day-06/part-1-input.txt")
# fish_test_data = Helper::upload("2021/day-06/test-input.txt")

def simulate_fish_population fish_data
    days = 256
    fish_data = fish_data[0].split(",").map(&:to_i)
    fish_array = [1,2,3,4,5]
    fish_array = fish_array.map {|fish| spawn(days - fish)}
    fish_count = 0
    fish_data.each do |fish|
        spawned_fish = fish_array[fish - 1]
        fish_count += spawned_fish
    end
    p fish_count
end

def spawn(days)
    return 1 if days === 0
    
    spawned_fish_baby = days - 9 >=0 ? spawn(days - 9) : 1
    spawned_fish_adult = days - 7 >=0 ? spawn(days - 7) : 1
    fishes = spawned_fish_baby + spawned_fish_adult
    
    fishes

end

simulate_fish_population fish_data