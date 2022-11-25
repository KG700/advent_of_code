require_relative '../helper'
include Helper

image_data = Helper::upload("2019/day-08/input.txt")

def find_layer data
    data = data[0].split("")
    data = data.each_slice(25 * 6).to_a

    min_zeros = Float::INFINITY
    num_ones = 0
    num_twos = 0
    
    data.each do |layer|
        num_zeros = layer.count("0")
        if num_zeros < min_zeros
            min_zeros = num_zeros
            num_ones = layer.count("1")
            num_twos = layer.count("2")
        end
    end
    p num_ones * num_twos
end

find_layer image_data