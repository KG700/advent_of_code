require_relative '../helper'
include Helper

COMPAS = ['N', 'E', 'S', 'W']

def drive_ship navigation

    position = [0,0]
    facing = 'E'

    navigation.each do |instruction|  
        action = instruction[0]
        move = instruction[1..-1].to_i
        case action
        when 'N', 'S', 'E', 'W'
            direction = action == 'E' || action == 'W' ? 0 : 1
            sign = action == 'N' || action == 'E' ? 1 : -1
            position[direction] += move * sign
        when 'L', 'R'
            sign = action == 'L' ? -1 : 1
            facing = COMPAS[(COMPAS.find_index(facing) + (move / 90 * sign)) % 4]
        when 'F'
            direction = facing == 'E' || facing == 'W' ? 0 : 1
            sign = facing == 'S' || facing == 'W' ? -1 : 1
            position[direction] += move * sign
        end

    end
    p position[0].abs + position[1].abs
end

nav_directions = Helper::upload("2020/day-12/navigation-data.txt")

test_nav = [
    "F10",
    "N3",
    "F7",
    "R90",
    "F11"
]

test_2_nav = [
    "F10",
    "N3",
    "F7",
    "R90",
    "F11",
    "R180",
    "F10",
    "L90",
    "F10"
]

drive_ship nav_directions