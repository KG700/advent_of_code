require_relative '../helper'
include Helper

fish_data = Helper::upload("day-06/part-1-input.txt")
# fish_test_data = Helper::upload("day-06/test-input.txt")

def simulate_fish_population fish_data

    fishes = []
    fish_data = fish_data[0].split(",").map(&:to_i)

    fish_data.each do |fish|
        spawned_fish = spawn(fish,80)
        spawned_fish.each { |fish| fishes.push(fish) }
    end
    # p fishes
    p fishes.length
end

def spawn(fish, days)
    return [fish] if days === 0

    fish = fish === 0 ? [7,9] : [fish]
    fishes = []
    fish.each do |f|
        spawned_fish = spawn(f - 1, days - 1)
        spawned_fish.each { |baby_fish| fishes.push(baby_fish) }
    end
    
    return fishes

end

simulate_fish_population fish_data