require_relative '../helper'
include Helper

binary_data = Helper::upload("2021/day-03/part-1-input.txt")
# binary_test_data = Helper::upload("day-03/test-input.txt")

def calculate_life_support binary_data
    oxygen_generator = find_rating(binary_data, 0, "high")
    co2_scrubber = find_rating(binary_data, 0, "low")
    p oxygen_generator.to_i(2) * co2_scrubber.to_i(2)
end

def calculate_diagnostic(binary_data, position, type)
    bit_first = type === "high" ? 1 : 0
    bit_second = type === "high" ? 0 : 1
    binary_data = binary_data.map { |data| data.split("") }
    binary_position_data = binary_data.transpose
    is_bit1 = binary_position_data[position].count("1") >= binary_position_data[position].size.to_f / 2
    gamma_rate = (is_bit1 ? bit_first : bit_second).to_s
end

def find_rating(binary_list, pos, type)
    return [] if binary_list.size === 0
    return binary_list[0] if binary_list.size === 1

    bit = calculate_diagnostic(binary_list, pos, type)
    binary_list_filered = binary_list.select {|binary| binary[pos] === bit}
    find_rating(binary_list_filered, pos + 1, type)
end

calculate_life_support binary_data