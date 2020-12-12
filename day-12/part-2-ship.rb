COMPAS = ['N', 'E', 'S', 'W']

def drive_ship navigation
    # p navigation

    position = [0, 0]
    waypoint = [10, 1]
    # facing = 'E'

    navigation.each do |instruction|  
        move = instruction[1..-1].to_i
        case instruction[0]
        when 'N'
            waypoint[1] += move
        when 'S'
            waypoint[1] -= move
        when 'E'
            waypoint[0] += move
        when 'W'
            waypoint[0] -= move
        when 'F'
            position[0] += waypoint[0] * move
            position[1] += waypoint[1] * move
        when 'L'
            waypoint.reverse! if move != 180
            waypoint[0] *= -1 if move == 90 || move == 180
            waypoint[1] *= -1 if move == 270 || move == 180
        when 'R'
            waypoint.reverse! if move != 180
            waypoint[1] *= -1 if move == 90 || move == 180
            waypoint[0] *= -1 if move == 270 || move == 180
        end
    end
    p position[0].abs + position[1].abs
end

def upload file
    file = File.open(file)
    file_data = file.readlines.map(&:chomp)
    file.close
    file_data
end

nav_directions = upload("day-12/navigation-data.txt")

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