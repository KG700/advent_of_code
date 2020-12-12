require_relative '../helper'
include Helper

expenses_data = Helper::upload("day-1/expenses-data.txt").map(&:to_i)

def multiples_of_2020(input_array)
    input_array.length.times do |first|  
        input_array.length.times do |second|
            element_sum = input_array[first] + input_array[second]
            if (first != second && element_sum == 2020)
                p input_array[first] * input_array[second]
                return
            end
        end
    end
    return "NO MATCHES"
end

multiples_of_2020 expenses_data