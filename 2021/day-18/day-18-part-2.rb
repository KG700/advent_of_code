require "set"
require "json"
require_relative '../helper'
include Helper

math_homework_test_1 = Helper::upload("2021/day-18/part-1-input.txt")

def add_snail_pairs math_homework_data

    math_homework_data.map! {|line| JSON.parse(line)}
    # p math_homework_data

    max_magnitude = 0
    max_math_1 = []
    max_math_2 = []
    max_added_line = []

    math_homework_data.each_with_index do |math_1, index_1|
        math_homework_data.each_with_index do |math_2, index_2|
            next if index_1 === index_2
            # p math_1
            # p math_2
            math_to_add = [math_1, math_2]

            something_happened = true
            while something_happened do
                math_after_explosion, explosion_happened = explode(Helper::deep_copy(math_to_add))
                # p "math_after_explosion: #{math_after_explosion}"
                math_after_split, split_happened = split_pair(Helper::deep_copy(math_after_explosion)) if !explosion_happened
                # p "math_after_split: #{math_after_split}" if !explosion_happened
                math_to_add = explosion_happened ? math_after_explosion : math_after_split
                something_happened = explosion_happened || split_happened
            end
            magnitude = find_magnitude(math_to_add)
            max_math_1 = math_1 if magnitude > max_magnitude
            max_math_2 = math_2 if magnitude > max_magnitude
            max_added_line = math_to_add if magnitude > max_magnitude
            max_magnitude = magnitude if magnitude > max_magnitude
        end
    end

    # p max_math_1
    # p max_math_2
    # p max_added_line
    p max_magnitude
    # end

    # p "LINE ADDED UP: #{math_left}"
    # p find_magnitude(math_left)

end

def explode(pair)
    # p "pair in explode #{pair}"
    nested_pair_found = false
    nested_pair = []

    pair.each_with_index do |pair_1, index_1|
        pair_1.each_with_index do |pair_2, index_2|
            pair_2.each_with_index do |pair_3, index_3|
                pair_3.each_with_index do |pair_4, index_4|
                    if pair_4.kind_of?(Array)
                        nested_pair = [index_1, index_2, index_3, index_4]
                        nested_pair_found = true
                    end
                    break if nested_pair_found
                end if pair_3.kind_of?(Array)
                break if nested_pair_found
            end if pair_2.kind_of?(Array)
            break if nested_pair_found
        end if pair_1.kind_of?(Array)
        break if nested_pair_found
    end if pair.kind_of?(Array)

    if nested_pair_found
        p1, p2, p3, p4 = nested_pair
        left_number = ""
        nested_pair_string = nested_pair.join
        
        left_number = find_number(pair, nested_pair_string + "0", "left")
        right_number = find_number(pair, nested_pair_string + "1", "right")

        if !left_number.empty?
            v,w,x,y,z = left_number.split("").map {|coord| coord.nil? ? coord : coord.to_i}
            if z
                pair[v][w][x][y][z] += pair[p1][p2][p3][p4][0]
            elsif y
                pair[v][w][x][y] += pair[p1][p2][p3][p4][0]
            elsif x
                pair[v][w][x] += pair[p1][p2][p3][p4][0]
            elsif w
                pair[v][w] += pair[p1][p2][p3][p4][0]
            elsif v
                pair[v] += pair[p1][p2][p3][p4][0]
            end
        end

        if right_number
            v,w,x,y,z = right_number.split("").map {|coord| coord.nil? ? coord : coord.to_i}
            # p pair[v][w][x][y][z]
            # p right_number
            if z
                pair[v][w][x][y][z] += pair[p1][p2][p3][p4][1]
            elsif y
                pair[v][w][x][y] += pair[p1][p2][p3][p4][1]
            elsif x
                pair[v][w][x] += pair[p1][p2][p3][p4][1]
            elsif w
                pair[v][w] += pair[p1][p2][p3][p4][1]
            elsif v
                pairv[v] += pair[p1][p2][p3][p4][1]
            end
        end
        
        pair[p1][p2][p3][p4] = 0
    end
    
    [pair, nested_pair_found]
end

def find_number(pair, coords, direction)

    found_number = ""
    next_pair = find_next_coords(coords, direction)
        loop do
            a,b,c,d,e = next_pair.split("").map {|coord| coord.nil? ? coord : coord.to_i}
            if !a.nil? && pair.kind_of?(Array)
                found_number = next_pair if pair[a].is_a?(Numeric) && b.nil? && c.nil? && d.nil? && e.nil?
                
                if !b.nil? && pair[a].kind_of?(Array)
                    found_number = next_pair if pair[a][b].is_a?(Numeric) && c.nil? && d.nil? && e.nil?

                    if !c.nil? && pair[a][b].kind_of?(Array)
                        found_number = next_pair if pair[a][b][c].is_a?(Numeric) && d.nil? && e.nil?

                        if !d.nil? && pair[a][b][c].kind_of?(Array)
                            found_number = next_pair if pair[a][b][c][d].is_a?(Numeric) && e.nil?

                            if !e.nil? && pair[a][b][c][d].kind_of?(Array)
                                found_number = next_pair if pair[a][b][c][d][e].is_a?(Numeric)
                            end
                        end
                    end
                end
            end

            break if !found_number.empty?

            next_pair = find_next_coords(next_pair, direction)
            break if next_pair.empty?

        end
    found_number
end

def find_next_coords(coords, direction)

    next_coords = ""
    if direction === "left"
        next_coords = coords[0...(coords.length - 1)]
        next_coords = (next_coords + "01111")[0..4] if coords[-1] === "1"
    else
        if coords.length < 5
            next_coords = coords + "0"
        elsif coords[-1] === "0"
            next_coords = coords[0..3] + "1"
        else
            n = nil
            coords.split("").reverse.each_with_index do |coord, index|
                if coord === "0"
                    n = coords.length - index - 1
                end
                break if !n.nil?
            end

            next_coords = coords[0...n] + "1"
        end     
    end
    next_coords
end

def split_pair(pair)
    # p "pair at start of split: #{pair}"
    pair_split_found = false
    pair_split = nil
    split_pair_coords = []

    pair.map! do |pair_1|
        if pair_1.is_a?(Numeric) && pair_1 >= 10 && !pair_split_found
            pair_1 = perform_split(pair_1)
            pair_split_found = true
        end

        if pair_1.kind_of?(Array)
            pair_1.map! do |pair_2|
                if pair_2.is_a?(Numeric) && pair_2 >= 10 && !pair_split_found
                    pair_2 = perform_split(pair_2)
                    pair_split_found = true
                end

                if pair_2.kind_of?(Array)
                    pair_2.map! do |pair_3|
                        if pair_3.is_a?(Numeric) && pair_3 >= 10 && !pair_split_found
                            pair_3 = perform_split(pair_3)
                            pair_split_found = true
                        end

                        if pair_3.kind_of?(Array)
                            pair_3.map! do |pair_4|
                                if pair_4.is_a?(Numeric) && pair_4 >= 10 && !pair_split_found
                                    pair_4 = perform_split(pair_4)
                                    pair_split_found = true
                                end

                                if pair_4.kind_of?(Array)
                                    pair_4.map! do |pair_5|
                                        if pair_5.is_a?(Numeric) && pair_5 >= 10 && !pair_split_found
                                            pair_5 = perform_split(pair_5)
                                            pair_split_found = true
                                        end
                                        pair_5
                                    end
                                end
                                pair_4
                            end
                        end
                        pair_3
                    end
                end
                pair_2
            end
        end
        pair_1
    end
    # p "pair in split: #{pair}"
    [pair, pair_split_found]

end

def perform_split(number)
    pair = [
        (number/2.0).floor,
        (number/2.0).ceil
    ]
end

def find_magnitude(snail_sum)
    return snail_sum if snail_sum.is_a?(Numeric)

    left = 3 * find_magnitude(snail_sum[0])
    right = 2 * find_magnitude(snail_sum[1])

    return left + right
end

add_snail_pairs math_homework_test_1

