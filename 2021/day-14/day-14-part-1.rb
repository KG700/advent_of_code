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

    10.times do |n|
        prev_char = nil
        next_polymer_template = polymer_template[0]
        polymer_template.each_char do |c|
            if prev_char.nil?
                prev_char = c
                next
            end
            next_polymer_template += polymer_list[prev_char + c] + c
            prev_char = c
        end
        polymer_template = next_polymer_template

    end
    min_char = polymer_template.length
    max_char = 0
    ("A".."Z").each do |char| 
        num_chars = polymer_template.count(char)
        min_char = num_chars if min_char > num_chars && num_chars > 0
        max_char = num_chars if max_char < num_chars
    end
    p max_char - min_char


end

find_polymer polymer_data