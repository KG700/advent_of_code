require "set"
require_relative '../helper'
include Helper

polymer_data = Helper::upload("2021/day-14/part-1-input.txt")
polymer_test_data = Helper::upload("2021/day-14/test-input.txt")

def find_polymer polymer_data
    # p polymer_data
    polymer_template = polymer_data[0]

    polymer_list = Hash.new
    
    polymer_data.drop(2).each do |list_item| 
        pair = list_item.split(" -> ")
        polymer_list[pair[0]] = pair[1]
    end

    # p polymer_list
    char_count = Hash.new(0)
    char_count[polymer_template[0]] = 1
    polymer_template.split("").each_cons(2) do |a,b|
        char_count_slice = find_next_char(a, b, 0, polymer_list)
        char_count = char_count_slice.merge(char_count) {|key, oldval, newval| newval + oldval}
        char_count[b] += 1
    end
    # p char_count

    min_char = char_count["B"]
    max_char = 0

    char_count.each do |key, val| 
        # num_chars = polymer_template.count(char)
        min_char = val if min_char > val && val > 0
        max_char = val if max_char < val
    end
    p max_char - min_char

    # 10.times do |n|
    #     prev_char = nil
    #     next_polymer_template = polymer_template[0]
    #     polymer_template.each_char do |c|
    #         if prev_char.nil?
    #             prev_char = c
    #             next
    #         end
    #         next_polymer_template += polymer_list[prev_char + c] + c
    #         prev_char = c
    #     end
    #     polymer_template = next_polymer_template

    # end



end

def find_next_char(a, b, level, list)
    # p "a: #{a}"
    # p "b: #{b}"
    next_char = list[a + b]
    if level === 39
        char_count = Hash.new(0)
        char_count[next_char] += 1
        return char_count
    end
    
    # p "level: #{level}"
    left_char_count = find_next_char(a, next_char, level + 1, list)
    right_char_count = find_next_char(next_char, b, level + 1, list)
    merged_char_count = left_char_count.merge(right_char_count) {|key, oldval, newval| newval + oldval}
    merged_char_count[next_char] += 1
    # p "left: #{left_char_count}"
    # p "right: #{right_char_count}"
    # p "merged: #{merged_char_count}"

    return merged_char_count
end

find_polymer polymer_data