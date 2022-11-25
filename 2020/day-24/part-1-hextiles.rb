require_relative '../helper'
include Helper

test_data = Helper::upload("2020/day-24/test-data.txt")
instructions_data = Helper::upload("2020/day-24/instructions-data.txt")

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
        # p instructions_hash
        # Reduce hash:
        # 1. remove pairs:
        PAIRS.each do |pair|
            remove_value = [instructions_hash[pair[0]],instructions_hash[pair[1]]].min
            instructions_hash[pair[0]] -= remove_value
            instructions_hash[pair[1]] -= remove_value
        end
        # p instructions_hash
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
        # p instructions_hash
        reduced_string = ""
        INSTRUCTIONS.each { |dir| reduced_string += "#{dir}:#{instructions_hash[dir]} " if instructions_hash[dir] > 0 }       
        if reduced_string.empty?
            reduced_instructions["ref"] += 1
        else
            reduced_instructions[reduced_string] += 1
        end
    end
    
    black_tiles = reduced_instructions.count { |inst, num| num.odd? }
    p black_tiles
end

lay_hextiles(instructions_data)

# hex
# east, southeast, southwest, west, northwest, and northeast
# e, se, sw, w, nw, ne