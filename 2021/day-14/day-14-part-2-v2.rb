require "set"
require_relative '../helper'
include Helper

polymer_data = Helper::upload("day-14/part-1-input.txt")
polymer_test_data = Helper::upload("day-14/test-input.txt")

def find_polymer polymer_data
    
    polymer_template = polymer_data[0]

    polymer_list = Hash.new
    
    polymer_data.drop(2).each do |list_item| 
        pair = list_item.split(" -> ")
        polymer_list[pair[0]] = pair[1]
    end

    polymer_count = Hash.new(0)
    polymer_template.split("").each_cons(2) {|a,b| polymer_count[a + b] += 1 }

    40.times do |n|
        polymer_next_count = Hash.new(0)
        polymer_count.each do |key, cnt|
            next_char = polymer_list[key]
            polymer_next_count[key[0] + next_char] += cnt
            polymer_next_count[next_char + key[1]] += cnt
        end
        polymer_count = polymer_next_count
    end

    char_count = Hash.new(0)
    char_count[polymer_template[0]] += 1
    char_count[polymer_template[-1]] += 1
    polymer_count.each do |key,val| 
        char_count[key[0]] += val
        char_count[key[1]] += val
    end

    min_char = char_count[polymer_template[0]]
    max_char = 0
    char_count.each do |char, cnt| 
        min_char = cnt if min_char > cnt
        max_char = cnt if max_char < cnt
    end
    p (max_char - min_char)/2

end

find_polymer polymer_data