require_relative '../helper'
include Helper

test_data = Helper::upload("day-24/test-data.txt")
instructions_data = Helper::upload("day-24/instructions-data.txt")

INSTRUCTIONS = ["se", "sw", "ne", "nw", "e", "w"]
PAIRS = [["nw", "se"], ["sw", "ne"], ["w", "e"]]
CIRCLES = [["w", "se", "ne"], ["e", "nw", "sw"]]
SHORTCUTS = [
    ["nw", "sw", "w"], 
    ["w", "se", "sw"], 
    ["sw", "e", "se"], 
    ["se", "ne", "e"], 
    ["e", "nw", "ne"], 
    ["ne", "w", "nw"]
]
NEIGHBOUR_COORDINATES = [
    [-1, 0],
    [0, -1],
    [1, -1],
    [1, 0],
    [0, 1],
    [-1, 1]
]

def lay_hextiles instructions
    reduced_instructions = Hash.new(0)
    instructions.each do |line|
        current_char = ""
        instructions_hash = Hash.new(0)
        line.each_char do |char|
            current_char += char
            case current_char
            when "se", "sw", "ne", "nw", "e", "w"
                instructions_hash[current_char] += 1
                current_char = ""
            end
        end

        # 1. remove pairs:
        PAIRS.each do |pair|
            remove_value = [instructions_hash[pair[0]],instructions_hash[pair[1]]].min
            instructions_hash[pair[0]] -= remove_value
            instructions_hash[pair[1]] -= remove_value
        end
        # 2. remove circles:
        CIRCLES.each do |circle|
            remove_value = [instructions_hash[circle[0]],instructions_hash[circle[1]],instructions_hash[circle[2]]].min
            instructions_hash[circle[0]] -= remove_value
            instructions_hash[circle[1]] -= remove_value
            instructions_hash[circle[2]] -= remove_value
        end
        # 3. find shortcuts
        SHORTCUTS.each do |shortcut|
            remove_value = [instructions_hash[shortcut[0]],instructions_hash[shortcut[1]]].min
            instructions_hash[shortcut[0]] -= remove_value
            instructions_hash[shortcut[1]] -= remove_value
            instructions_hash[shortcut[2]] += remove_value
        end

        # 5. transform into coordinates string and add to reduced_instructions 
        reduced_string = ""
        INSTRUCTIONS.each { |dir| reduced_string += "#{dir}:#{instructions_hash[dir]} " if instructions_hash[dir] > 0 }       
        if reduced_string.empty?
            reduced_instructions["ref"] += 1
        else
            reduced_instructions[reduced_string] += 1
        end
    end

    all_tiles = Marshal.load(Marshal.dump(reduced_instructions))

    100.times do
    all_tiles_with_neighbours = Marshal.load(Marshal.dump(all_tiles))
        all_tiles.each do |tile, count|
            individual_tile = tile.split(" ")
            individual_tile = individual_tile.map { |t| t.split(":") }
            neighbours = find_neighbours(individual_tile)
            neighbours.each { |neighbour| all_tiles_with_neighbours[neighbour] = 0 if !all_tiles_with_neighbours.key?(neighbour) }
        end

        next_instructions = Marshal.load(Marshal.dump(all_tiles_with_neighbours))
        all_tiles_with_neighbours.each do |tile, count|
            individual_tile = tile.split(" ")
            individual_tile = individual_tile.map { |t| t.split(":") }
            neighbours = find_neighbours(individual_tile)
            black_tiles = neighbours.count { |neighbour| all_tiles[neighbour].odd? }
            flip_value = 0
            flip_value = 1 if count.odd? && (black_tiles == 0 || black_tiles > 2)
            flip_value = 1 if count.even? && black_tiles == 2
            next_instructions[tile] += flip_value
        end

        all_tiles = Marshal.load(Marshal.dump(next_instructions))
    end
    black_tiles = all_tiles.count { |inst, num| num.odd? }
    p black_tiles
end

def find_neighbours tile
    neighbours = []
    if tile.length == 2
        NEIGHBOUR_COORDINATES.each do |coordinates|
            tile_label = ""
            tile.each_with_index do |dir, index| 
                tile_label += "#{dir[0]}:#{dir[1].to_i + coordinates[index]} " if dir[1].to_i + coordinates[index] > 0
            end
            tile_label = "ref" if tile_label.empty?
            neighbours.push(tile_label)
        end
        return neighbours
    end

    if tile.length == 1
        neighbours_hashes = []
        if tile[0][0] == "ref"
            INSTRUCTIONS.each do |dir|
                neighbours_hashes.push({ dir => 1 })
            end
        else
            shortcut = SHORTCUTS.find { |dir| dir[2] == tile[0][0] }
            shortcut.each do |dir|
                if dir == tile[0][0]
                    neighbours_hashes.push({ tile[0][0] => tile[0][1].to_i + 1 })
                    neighbours_hashes.push({ tile[0][0] => tile[0][1].to_i - 1 })
                else
                    neighbours_hashes.push({ dir => 1, tile[0][0] => tile[0][1].to_i })
                    neighbours_hashes.push({ dir => 1, tile[0][0] => tile[0][1].to_i - 1 })
                end
            end
        end
        neighbours_hashes.each do |neighbour|
            tile_label = ""
            INSTRUCTIONS.each do |dir|
                if neighbour.key?(dir)
                    tile_label += "#{dir}:#{neighbour[dir]} " if neighbour[dir] > 0
                end
            end
            tile_label = "ref" if tile_label.empty?
            neighbours.push(tile_label)
        end
        return neighbours
    end

end

lay_hextiles(instructions_data)