require_relative '../helper'
include Helper

data = Helper::upload("2022/day-14/input.txt")
data_test = Helper::upload("2022/day-14/input-test.txt")

def calculate data
    walls = data.map { |wall| wall.split(" -> ") }
    floor = 0
    min_left = 500
    max_right = 500

    scan = {}
    
    walls.each do |wall|
        rock, *corners = wall

        corners.each do |corner|
            x_rock, y_rock = rock.split(',').map(&:to_i)
            x_corner, y_corner = corner.split(',').map(&:to_i)
            floor = [floor, y_corner, y_rock].max
            min_left = [min_left, x_rock, x_corner].min
            max_right = [max_right, x_rock, x_corner].max

            if x_rock != x_corner
                if x_rock < x_corner
                    (x_rock..x_corner).each { |x_coord| scan["#{x_coord},#{y_rock}"] = '#' }
                else    
                    (x_rock).downto(x_corner).each { |x_coord| scan["#{x_coord},#{y_rock}"] = '#' }
                end
            else
                if y_rock < y_corner
                    (y_rock..y_corner).each { |y_coord| scan["#{x_rock},#{y_coord}"] = '#' }
                else
                    (y_rock).downto(y_corner).each { |y_coord| scan["#{x_rock},#{y_coord}"] = '#' }
                end
            end
            rock = corner
        end

    end

    floor += 2
    min_left -= 2
    max_right += 2

    (min_left..max_right).each { |x_coord| scan["#{x_coord},#{floor}"] = '#'}

    i = 0
    sand_count = 0
    loop do
        sand = [500,0]
        x,y = sand
        sand_down = [x, y + 1]
        sand_diagonal_left = [x - 1, y + 1]
        sand_diagonal_right = [x + 1, y + 1]

        loop do

            if sand[1] + 1 == floor
                scan["#{min_left - 1},#{floor}"] = '#'
                scan["#{min_left - 2},#{floor}"] = '#'
                scan["#{max_right + 1},#{floor}"] = '#'
                scan["#{max_right + 2},#{floor}"] = '#'
                min_left -= 2
                max_right += 2
            end

            if scan[sand_down.join(",")].nil?
                x, y = sand_down
                sand, sand_down, sand_diagonal_left, sand_diagonal_right = falling_sand x, y
            elsif scan[sand_diagonal_left.join(",")].nil?
                x, y = sand_diagonal_left
                sand, sand_down, sand_diagonal_left, sand_diagonal_right = falling_sand x, y
            elsif scan[sand_diagonal_right.join(",")].nil?
                x, y = sand_diagonal_right
                sand, sand_down, sand_diagonal_left, sand_diagonal_right = falling_sand x, y
            else
                scan["#{sand[0]},#{sand[1]}"] = 'o'
                sand_count += 1
                break
            end

            break if sand == [500, 0]
            break if sand[1] >= floor

        end
        i += 1
        break if sand[1] < 0
        break if sand == [500, 0]
        break if sand[1] >= floor
    end

    p sand_count

end

def falling_sand x, y
    sand = [x, y]
    down = [x, y + 1]
    diagonal_left = [x - 1, y + 1]
    diagonal_right = [x + 1, y + 1]
    [sand, down, diagonal_left, diagonal_right]
end

calculate data