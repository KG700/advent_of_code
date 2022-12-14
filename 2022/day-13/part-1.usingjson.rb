require 'json'
require_relative '../helper'
include Helper

data = Helper::upload_line_break("2022/day-13/input.txt")
data_test = Helper::upload_line_break("2022/day-13/input-test.txt")

def calculate data
    pairs = data.map! { |pairs| pairs.split(/\n/) }

    number_in_right_order = 0

    pairs.each_with_index do |pair, index| 
        pair_1, pair_2 = pair

        pair_1 = JSON.parse(pair_1)
        pair_2 = JSON.parse(pair_2)

        right_order = compare(pair_1, pair_2)
        number_in_right_order += index + 1 if right_order

    end
    p number_in_right_order
end

def compare pair_1, pair_2
    is_right_order = nil
    pair_1.each_with_index do |pair, index|
        if index >= pair_2.length 
            return false
        elsif pair.kind_of?(Array) && pair_2[index].kind_of?(Array)
            is_right_order = compare(pair, pair_2[index])
            return is_right_order unless is_right_order.nil?
        elsif pair.kind_of?(Array)
            is_right_order = compare(pair, [pair_2[index]])
            return is_right_order unless is_right_order.nil?
        elsif pair_2[index].kind_of?(Array)
            is_right_order = compare([pair], pair_2[index])
            return is_right_order unless is_right_order.nil?
        elsif pair.to_i != pair_2[index].to_i
            return pair.to_i < pair_2[index].to_i
        end
    end

    if pair_1.length < pair_2.length
        return true
    end
    is_right_order
end

calculate data