require_relative '../helper'
include Helper

expenses_data = Helper::upload("day-1/expenses-data.txt").map(&:to_i)

def multiples_of_2020(input_array)
    input_array.length.times do |first|  
        input_array.length.times do |second|
            input_array.length.times do |third|
                element_sum = input_array[first] + input_array[second] + input_array[third]
                if (first != second && first != third && element_sum == 2020)
                    p input_array[first] * input_array[second] * input_array[third]
                    return
                end
            end
        end
    end
    return "NO MATCHES"
end

multiples_of_2020 expenses_data