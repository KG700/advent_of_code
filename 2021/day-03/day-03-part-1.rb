require_relative '../helper'
include Helper

binary_data = Helper::upload("day-03/part-1-input.txt")
# binary_test_data = Helper::upload("day-03/test-input.txt")

def calculate_diagnostic binary_data

    binary_data.map! { |data| data.split("") }
    binary_position_data = binary_data.transpose
    gamma_rate = []
    epsilon_rate = []
    binary_position_data.each do |pos|
        is_bit1 = pos.count("1") > pos.size / 2
        gamma_rate.push is_bit1 ? 1 : 0
        epsilon_rate.push is_bit1 ? 0 : 1
    end
    power_consumption = gamma_rate.join().to_i(2) * epsilon_rate.join().to_i(2)
    p power_consumption

end

calculate_diagnostic binary_data