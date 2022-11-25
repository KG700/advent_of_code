require_relative '../helper'
include Helper

mask_data = Helper::upload("day-14/bit-mask-data.txt")

def sum_of_numbers_in_memory mask_data
    mask_data.map! { |data| data.split(" = ") }

    mask = ''
    memory = {}
    mask_data.each do |data|
        if data[0] == "mask"
            mask = data[1].split('')
        else
            data[0].slice!("mem[")
            data[0].slice!("]")
            binary_number = data[1].to_i.to_s(2).rjust(36,"0").split('')
            binary_number = binary_number.each_with_index.map { |bit, index| bit = mask[index] != 'X' ? mask[index] : bit  }
            binary_number = binary_number.join
            memory[data[0]] = binary_number.to_i(2)
        end
    end
    sum = 0
    memory.each { |mem, val| sum += val }
    p sum
end

sum_of_numbers_in_memory mask_data
