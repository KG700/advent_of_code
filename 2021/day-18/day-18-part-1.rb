require "set"
require "json"
require_relative '../helper'
include Helper

math_homework_test_1 = Helper::upload("2021/day-18/part-1-input.txt")

def add_snail_pairs math_homework_data

    math_homework_data.map! {|line| JSON.parse(line)}

    math_left = math_homework_data[0]
    math_list = math_homework_data[1..-1]
    math_to_add = []

    # p [math_homework_data[0], math_homework_data[1]]
    math_list.each do |math_line|
        # p "in main part"
        # p math_left
        # p math_line
        math_to_add = [math_left, math_line]
        # p math_to_add
        # p "++++"
        # p math_to_add[0][0][0][0][0]
        # p math_to_add[0][0][0][0][1]
        # p math_to_add[0][0][0][1]
        # p math_to_add[0][0][0][1][0]
        # p math_to_add[0][0][0][1][1]
        # p math_to_add[0][0][1]
        # p math_to_add[0][0][1][0]
        # p "++++"

        something_happened = true
        while something_happened do
            something_happened = explode(math_to_add)
            something_happened = split_pair(math_to_add) if !something_happened
            something_happened
        end
        math_left = math_to_add
        # p math_left
    end

    p "LINE ADDED UP: #{math_left}"

    p find_magnitude(math_left)

    # p find_magnitude([[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]])

end

def explode(pair)
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
        # p "nested_pair: #{pair[p1][p2][p3][p4]}"
        left_number = ""
        nested_pair_string = nested_pair.join
        
        left_number = find_number(pair, nested_pair_string + "0", "left")
        right_number = find_number(pair, nested_pair_string + "1", "right")
        # p "left_number: #{left_number}"
        # p "right_number: #{right_number}"

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
        # p "pair after explosion: #{pair}" if nested_pair_found
    end
    
    nested_pair_found
end

def find_number(pair, coords, direction)
    # p "-------"
    # p coords
    found_number = ""
    next_pair = find_next_coords(coords, direction)
    # p next_pair
        loop do
            a,b,c,d,e = next_pair.split("").map {|coord| coord.nil? ? coord : coord.to_i}
            if !a.nil? && pair.kind_of?(Array)
                # p "In: a"
                found_number = next_pair if pair[a].is_a?(Numeric) && b.nil? && c.nil? && d.nil? && e.nil?
                # p found_number
                
                if !b.nil? && pair[a].kind_of?(Array)
                    # p "In: b"
                    # p pair[a][b]
                    found_number = next_pair if pair[a][b].is_a?(Numeric) && c.nil? && d.nil? && e.nil?
                    # p found_number

                    if !c.nil? && pair[a][b].kind_of?(Array)
                        # p "In: c"
                        # p pair[a][b][c]
                        found_number = next_pair if pair[a][b][c].is_a?(Numeric) && d.nil? && e.nil?
                        # p found_number

                        if !d.nil? && pair[a][b][c].kind_of?(Array)
                            # p "In: d"
                            # p pair[a][b][c][d]
                            found_number = next_pair if pair[a][b][c][d].is_a?(Numeric) && e.nil?
                            # p found_number

                            if !e.nil? && pair[a][b][c][d].kind_of?(Array)
                                # p "In: d"
                                # p pair[a][b][c][d]
                                found_number = next_pair if pair[a][b][c][d][e].is_a?(Numeric)
                                # p found_number
                            end
                        end
                    end
                end
            end

            # p found_number

            break if !found_number.empty?

            next_pair = find_next_coords(next_pair, direction)
            # p "next_pair: #{next_pair}"
            break if next_pair.empty?

        end
    # p "||||||||"
    found_number
end

def find_next_coords(coords, direction)
    # p coords
    # p coords.length
    next_coords = ""
    if direction === "left"
        next_coords = coords[0...(coords.length - 1)]
        next_coords = (next_coords + "01111")[0..4] if coords[-1] === "1"
    else
        if coords.length < 5
            # p "case 1"
            next_coords = coords + "0"
        elsif coords[-1] === "0"
            # p "case 2"
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
    # p next_coords
    next_coords
end

def split_pair(pair)

    pair_split_found = false
    pair_split = nil
    split_pair_coords = []

    pair.map! do |pair_1|
        if pair_1.is_a?(Numeric) && pair_1 >= 10 && !pair_split_found
            pair_1 = perform_split(pair_1)
            # split_pair_coords = [index_1]
            pair_split_found = true
        end
        # break if pair_split_found

        if pair_1.kind_of?(Array)
            pair_1.map! do |pair_2|
                if pair_2.is_a?(Numeric) && pair_2 >= 10 && !pair_split_found
                    pair_2 = perform_split(pair_2)
                    # split_pair_coords = [index_1, index_2]
                    pair_split_found = true
                end
                # break if pair_split_found

                if pair_2.kind_of?(Array)
                    pair_2.map! do |pair_3|
                        if pair_3.is_a?(Numeric) && pair_3 >= 10 && !pair_split_found
                            pair_3 = perform_split(pair_3)
                            # split_pair_coords = [index_1, index_2, index_3]
                            pair_split_found = true
                        end
                        # break if pair_split_found

                        if pair_3.kind_of?(Array)
                            pair_3.map! do |pair_4|
                                if pair_4.is_a?(Numeric) && pair_4 >= 10 && !pair_split_found
                                    pair_4 = perform_split(pair_4)
                                    # split_pair_coords = [index_1, index_2, index_3, index_4]
                                    pair_split_found = true
                                end
                                # break if pair_split_found

                                if pair_4.kind_of?(Array)
                                    pair_4.map! do |pair_5|
                                        if pair_5.is_a?(Numeric) && pair_5 >= 10 && !pair_split_found
                                            pair_5 = perform_split(pair_5)
                                            # split_pair_coords = [index_1, index_2, index_3, index_4]
                                            pair_split_found = true
                                        end
                                        # break if pair_split_found
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

    # p split_pair_coords
    # p "pair after split: #{pair}" if pair_split_found
    pair_split_found

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

