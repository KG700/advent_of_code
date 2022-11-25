require_relative '../helper'
include Helper

cube_data = Helper::upload("2020/day-17/starting-cube.txt")
test_data = [
    ".#.",
    "..#",
    "###"
]

OPERATIONS = [
    [-1, -1, -1, -1],
    [-1, -1, -1, 0],
    [-1, -1, -1, 1],
    [-1, -1, 0, -1],
    [-1, -1, 0, 0],
    [-1, -1, 0, 1],
    [-1, -1, 1, -1],
    [-1, -1, 1, 0],
    [-1, -1, 1, 1],
    [-1, 0, -1, -1],
    [-1, 0, -1, 0],
    [-1, 0, -1, 1],
    [-1, 0, 0, -1],
    [-1, 0, 0, 0],
    [-1, 0, 0, 1],
    [-1, 0, 1, -1],
    [-1, 0, 1, 0],
    [-1, 0, 1, 1],
    [-1, 1, -1, -1],
    [-1, 1, -1, 0],
    [-1, 1, -1, 1],
    [-1, 1, 0, -1],
    [-1, 1, 0, 0],
    [-1, 1, 0, 1],
    [-1, 1, 1, -1],
    [-1, 1, 1, 0],
    [-1, 1, 1, 1],    
    [0, -1, -1, -1],
    [0, -1, -1, 0],
    [0, -1, -1, 1],
    [0, -1, 0, -1],
    [0, -1, 0, 0],
    [0, -1, 0, 1],
    [0, -1, 1, -1],
    [0, -1, 1, 0],
    [0, -1, 1, 1],
    [0, 0, -1, -1],
    [0, 0, -1, 0],
    [0, 0, -1, 1],
    [0, 0, 0, -1],
    [0, 0, 0, 1],
    [0, 0, 1, -1],
    [0, 0, 1, 0],
    [0, 0, 1, 1],
    [0, 1, -1, -1],
    [0, 1, -1, 0],
    [0, 1, -1, 1],
    [0, 1, 0, -1],
    [0, 1, 0, 0],
    [0, 1, 0, 1],
    [0, 1, 1, -1],
    [0, 1, 1, 0],
    [0, 1, 1, 1],
    [1, -1, -1, -1],
    [1, -1, -1, 0],
    [1, -1, -1, 1],
    [1, -1, 0, -1],
    [1, -1, 0, 0],
    [1, -1, 0, 1],
    [1, -1, 1, -1],
    [1, -1, 1, 0],
    [1, -1, 1, 1],
    [1, 0, -1, -1],
    [1, 0, -1, 0],
    [1, 0, -1, 1],
    [1, 0, 0, -1],
    [1, 0, 0, 0],
    [1, 0, 0, 1],
    [1, 0, 1, -1],
    [1, 0, 1, 0],
    [1, 0, 1, 1],
    [1, 1, -1, -1],
    [1, 1, -1, 0],
    [1, 1, -1, 1],
    [1, 1, 0, -1],
    [1, 1, 0, 0],
    [1, 1, 0, 1],
    [1, 1, 1, -1],
    [1, 1, 1, 0],
    [1, 1, 1, 1]
        
    ]

def conway_cube data
    cube = Hash.new(".")
    data.each_with_index{ |row, x| row.split("").each_with_index { |value, y| cube[[0, x, y, 0]] = value } }
    
    cycle = 0

    loop do
        cube = add_extra_dimension(cube)
 
        next_cube = {}
        cube.each do |position, value|
            neighbours = find_neighbours(cube, position)
            if value == "#"
                next_cube[position] = neighbours.count("#") == 2 || neighbours.count("#") == 3 ? "#" : "."
            else
                next_cube[position] = neighbours.count("#") == 3 ? "#" : "."
            end
        end
        cycle += 1
        cube = Marshal.load(Marshal.dump(next_cube))
        break if cycle == 6
    end

    p count_active(cube)
    
end

def count_active cube
    active = 0
    cube.each { |key, value| active += 1 if value == "#" }
    active
end

def add_extra_dimension cube
    new_cube = {}
    cube.each do |position, value|
        OPERATIONS.each do |op|
            new_position = op.each_with_index.map { |x, i| position[i] + x  }
            new_cube[new_position] = cube.key?(new_position) ? cube[new_position] : "."
        end
    end
    new_cube
end

def find_neighbours cube, position
    neighbours = []
    OPERATIONS.each do |op|
        neighbour = op.each_with_index.map { |x, i| position[i] + x  }
        neighbours.push(cube[neighbour])
    end
    neighbours
end

conway_cube(cube_data)
