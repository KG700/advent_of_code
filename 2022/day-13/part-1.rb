require_relative '../helper'
include Helper

data = Helper::upload_line_break("2022/day-13/input.txt")
data_test = Helper::upload_line_break("2022/day-13/input-test.txt")

def calculate data
    pairs = data.map! { |pairs| pairs.split(/\n/) }

    number_in_right_order = 0

    pairs.each_with_index do |pair, index| 
        pair_1, pair_2 = pair

        pair_1, len = create_array pair_1[1..-1]
        pair_2, len = create_array pair_2[1..-1]

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
        elsif pair.empty? && !pair_2[index].empty?
            return true
        elsif !pair.empty? && pair_2[index].empty?
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

def create_array pair
    pair_array = []
    i = 0
    item = ""
    loop do
        case pair[i]
        when "["
            item, item_length = create_array(pair[(i + 1)..-1])
            i += item_length + 1
        when ","
            pair_array.push(item)
            item = ""
        when ']'
            pair_array.push(item)
            return [pair_array, i]
        else
            item += pair[i]
        end

        break if i >= pair.length - 1
        i += 1
    end
    pair_array
end

calculate data