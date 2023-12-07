require_relative '../helper'
include Helper

data = Helper::upload_line_break("2023/day-05/input.txt")
data_test = Helper::upload_line_break("2023/day-05/input-test.txt")

def calculate data
    seeds, *maps_data = data
    seed_label, *seeds = seeds.split(" ").map(&:to_i)
    seed_ranges = seeds.each_slice(2).to_a

    categories = []

    maps_data.each_with_index do |map_data, index|
        category_label, *maps = map_data.split(/\n/)
        category_label = category_label.split(" ")[0]
        category = Category.new(category_label)
        
        if index > 0
            categories[index - 1].update_destination_category(category)
            category.update_source_category(categories[index - 1])
            category.update_maximum(categories[index - 1].maximum)
        end

        category.create_map(maps)

        categories.push(category)
    end

    min_location = Float::INFINITY
    seed_ranges.each do |seed_range|
        seed_low, seed_diff = seed_range

        categories[0].maps.each do |category_range|
            category_low, category_high = category_range[0]

            if seed_low >= category_low && seed_low + seed_diff - 1 <= category_high
                min_location = [min_location, categories[0].get_location(seed_low)].min
                break
            end

            if category_low >= seed_low && category_low <= seed_low + seed_diff - 1
                min_location = [min_location, categories[0].get_location(category_low)].min
            end

        end
    end

    min_location

end


class Category
    attr_accessor :name, :maps, :maximum

    def initialize name
        @name = name
        @maps = []
        @source_category = 'seed'
        @destination_category = 'location'
        @maximum = 0
    end

    def create_map maps
        maps_array = maps.map { |map| map.split(" ").map(&:to_i) }
        maps_array = maps_array.sort_by { |map| map[1] }
        self.update_maximum(maps_array.last[1] + maps_array.last[1])
        marker = 0
        maps_array.each do |map|
            destination, source, diff = map
            if marker < destination
                @maps.push([
                    [marker, source - 1], [marker, source - 1],
                ])
                @source_category.update_map(marker, source - 1) if @source_category != 'seed'
            end
            @maps.push([
                [source, source + diff - 1],
                [destination, destination + diff - 1]
            ])
            @source_category.update_map(source, source + diff - 1) if @source_category != 'seed'
            marker = destination + diff
        end

        if marker < @maximum
            @maps.push([
                [marker, @maximum], [marker, @maximum]
            ])
            @source_category.update_map(marker, @maximum) if @source_category != 'seed'
        end

    end

    def update_map low, high
        new_map = []
        @maps.each do |range|
            source_range, destination_range = range

            if low > destination_range[1]
                new_map.push(range)

            elsif high < destination_range[0]
                new_map.push(range)

            elsif low < destination_range[0] && high <= destination_range[1]
                diff = high - destination_range[0]
                new_map.push([
                    [source_range[0], source_range[0] + diff], 
                    [destination_range[0], high]
                ])
                @source_category.update_map(source_range[0], source_range[0] + diff) if @source_category != 'seed'
                if high < destination_range[1]
                    new_map.push([
                        [source_range[0] + diff + 1, source_range[1]],
                        [high + 1, destination_range[1]]
                    ])
                    @source_category.update_map(source_range[0] + diff + 1, source_range[1]) if @source_category != 'seed'
                end

            elsif low < destination_range[0] && high > destination_range[1]
                new_map.push(range)

            elsif low >= destination_range[0] && high <= destination_range[1]
                diff_low = low - destination_range[0]
                diff_high = destination_range[1] - high

                if low > destination_range[0]
                    new_map.push([
                        [source_range[0], source_range[0] + diff_low - 1],
                        [destination_range[0], low - 1]
                    ])
                    @source_category.update_map(source_range[0], source_range[0] + diff_low - 1) if @source_category != 'seed'
                end

                new_map.push([[source_range[0] + diff_low, source_range[1] - diff_high], [low, high]])
                @source_category.update_map(source_range[0] + diff_low, source_range[1] - diff_high) if @source_category != 'seed'

                if high < destination_range[1]
                    new_map.push([
                        [source_range[1] - diff_high + 1, source_range[1]],
                        [high + 1, destination_range[1]]
                    ])
                    @source_category.update_map(source_range[1] - diff_high + 1, source_range[1]) if @source_category != 'seed'
                end

            elsif low >= destination_range[0] && high > destination_range[1]
                diff = low - destination_range[0]

                if low > destination_range[0]
                    new_map.push([
                        [source_range[0], source_range[0] + diff - 1],
                        [destination_range[0], low - 1]
                    ])
                    @source_category.update_map(source_range[0], source_range[0] + diff - 1) if @source_category != 'seed'
                end

                new_map.push([
                    [source_range[0] + diff, source_range[1]], 
                    [low, destination_range[1]]
                ])

                @source_category.update_map(source_range[0] + diff, source_range[1]) if @source_category != 'seed'

            else
                "Error"
            end

        end
        @maps = new_map
    end

    def get_destination source
        selected_map = @maps.select { |map| source >= map[0][0] && source <= map[0][1] }
            
        diff = source - selected_map[0][0][0]
        selected_map[0][1][0] + diff
    end

    def get_location source
        destination = self.get_destination(source)
        if @destination_category === 'location'
            return destination
        else
            return @destination_category.get_location destination   
        end
    end

    def update_source_category source_category
        @source_category = source_category
    end 

    def update_destination_category destination_category
        @destination_category = destination_category
    end 

    def update_maximum max
        @maximum = [@maximum, max].max
    end
end

p calculate data
