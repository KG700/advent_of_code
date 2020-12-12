COMPAS = ['N', 'E', 'S', 'W']

def drive_ship navigation
    # p navigation

    position = [0,0]
    facing = 'E'

    navigation.each do |instruction|  
        move = instruction[1..-1].to_i
        case instruction[0]
        when 'N'
            position[1] += move
        when 'S'
            position[1] -= move
        when 'E'
            position[0] += move
        when 'W'
            position[0] -= move
        when 'F'
            direction = facing == 'E' || facing == 'W' ? 0 : 1
            sign = facing == 'S' || facing == 'W' ? -1 : 1
            position[direction] += move * sign
        when 'L'
            facing = COMPAS[(COMPAS.find_index(facing) - (move / 90)) % 4]
        when 'R'
            facing = COMPAS[(COMPAS.find_index(facing) + (move / 90)) % 4]
        end
        # p instruction
        # p facing
        # p position
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