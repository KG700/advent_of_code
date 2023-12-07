require_relative '../helper'
include Helper

data = Helper::upload_line_break("2023/day-05/input.txt")
data_test = Helper::upload_line_break("2023/day-05/input-test.txt")

def calculate data
    seeds, *maps_data = data
    label, *seeds = seeds.split(" ").map(&:to_i)

    seeds.reduce(Float::INFINITY) do |minimum, seed|
        location = maps_data.reduce(seed) do |from, map|
            label, *maps = map.split(/\n/)
            maps = maps.map { |map| map.split(" ").map(&:to_i) }
            selected_map = maps.select { |map| from >= map[1] && from <= (map[1] + map[2] - 1) }

            if selected_map.length == 0
                next_value = from
            else
                diff = from - selected_map[0][1]
                next_value = selected_map[0][0] + diff
            end

            from = next_value
        end

        minimum = location < minimum ? location : minimum
    end
end

p calculate data