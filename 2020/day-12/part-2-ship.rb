require_relative '../helper'
include Helper

def drive_ship navigation

    position = [0, 0]
    waypoint = [10, 1]

    navigation.each do |instruction|  
        action = instruction[0]
        move = instruction[1..-1].to_i
        case action
        when 'N', 'S', 'E', 'W'
            direction = action == 'E' || action == 'W' ? 0 : 1
            sign = action == 'N' || action == 'E' ? 1 : -1
            waypoint[direction] += move * sign
        when 'L', 'R'
            direction = action == 'L' ? 0 : 1
            waypoint.reverse! if move != 180
            waypoint[direction] *= -1 if move == 90 || move == 180
            waypoint[(1 - direction).abs] *= -1 if move == 270 || move == 180
        when 'F'
            position = position.each_with_index.map { |pos, index| pos + waypoint[index] * move }
        end
    end
    p position[0].abs + position[1].abs
end

nav_directions = Helper::upload("day-12/navigation-data.txt")

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