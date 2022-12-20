require 'set'
require_relative '../helper'
include Helper

data = Helper::upload("2022/day-12/input.txt")
data_test = Helper::upload("2022/day-12/input-test.txt")

DIRECTIONS = [[-1, 0], [0, 1], [1, 0], [0, -1]]

def calculate height_map

    end_position = []
    height_map.each_with_index do |line, x| 
        line.chars.each_with_index do |pos, y| 
            end_position = [x, y] if height_map[x][y] == "E"
            height_map[x][y] = 'a' if height_map[x][y] == "S"
            height_map[x][y] = 'z' if height_map[x][y] == "E"
        end
    end

    min_moves = Float::INFINITY

    height_map.each_with_index do |line, i|
        line.chars.each_with_index do |elevation, j|
            next unless elevation == 'a'
            visited = Set.new
            moves = {}
            moves["#{i},#{j}"] = 0

            queue = [[i,j]]

            loop do
                break if queue.length == 0
                position = queue.shift
                visited.add(position.join(","))

                DIRECTIONS.each do |direction|
                    x, y = position
                    current_elevation = height_map[x][y]
                    x += direction[0]
                    y += direction[1]
                    in_map = x >= 0 && x < height_map.length && y >= 0 && y < height_map[0].length
                    next unless in_map
                    next_elevation = height_map[x][y]
                    if in_map && (current_elevation == 'S' || current_elevation.ord - next_elevation.ord > -2)
                        queue.push([x,y]) unless visited.include?("#{x},#{y}") || queue.include?([x,y])
                        move = moves[position.join(",")] + 1
                        moves["#{x},#{y}"] = moves.key?("#{x},#{y}") ? [ moves["#{x},#{y}"], move].min : move
                    end
                end
            end
            min_moves = moves[end_position.join(",")] ? [moves[end_position.join(",")], min_moves].min : min_moves
        end
    end
    p min_moves

end

calculate data