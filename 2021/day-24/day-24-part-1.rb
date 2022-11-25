require_relative '../helper'
include Helper

monad_data = Helper::upload("2021/day-24/input.txt")
monad_data_test = Helper::upload("2021/day-24/test-input.txt")

def validate_model_number monad_data
    # p 0 % 26
    model_number = '99915913911491'
    # model_number = '22915913911491'
    data = monad_data.map {|line| line.split(" ") }

    # variable_accessor = build_variable_accessor(data)
    value_accessor = {'w' => 0, 'x' => 0, 'y' => 0, 'z' => 0}
    # p variable_accessor
    # p value_accessor

    n = 0
    loop do
        # p "checking model_number: #{model_number}"
        value_accessor = {'w' => 0, 'x' => 0, 'y' => 0, 'z' => 0}
        is_valid = false

        if model_number.count('0') === 0
            processing_unit = run_ALU(data, model_number, value_accessor)
            # p processing_unit
            is_valid = processing_unit['z'] === 0
        end

        # p "is valid?: #{is_valid}"

        break if is_valid

        model_number = (model_number.to_i + 1).to_s
        n += 1
        # break if n === 100 #dev purposes
        break if model_number.to_i > 99999999999999
    end

    p "-----"
    p model_number

end

def build_variable_accessor input
    n = 0
    variable_accessor = {}

    input.each do |line|
        if line[0] === 'inp'
            variable_accessor[n] = line[1]
            n += 1
        end

    end
    variable_accessor
end

# def initiate_value_accessor(model_number, variable_accessor)
#     value_accessor = {}
#     model_number.split("").each_with_index do |num, index|
#         value_accessor[variable_accessor[index]] = num.to_i
#     end
#     value_accessor
# end

def run_ALU(instructions, model_number, value_accessor)
    n = 0
    second_number = 0
    instructions.each_with_index do |line, index|
        second_number = value_accessor.key?(line[2]) ? value_accessor[line[2]] : line[2].to_i

        case line[0]
        when 'inp'
            break if n === model_number.length
            # p n
            value_accessor[line[1]] = model_number[n].to_i
            n += 1
        when 'add'
            value_accessor[line[1]] += second_number
        when 'mul'
            value_accessor[line[1]] *= second_number
        when 'div'
            if second_number != 0
                value_accessor[line[1]] /= second_number if second_number != 0
            else
                p "Error: #{second_number} is zero. Can't divide"
            end
        when 'mod'
            if (value_accessor[line[1]] >= 0 && second_number >= 0)
                value_accessor[line[1]] = value_accessor[line[1]] % second_number
            else
                p "Error:#{value_accessor[line[1]]} or #{second_number} is less than zero. Can't do modulo"
            end
        when 'eql'
            is_same = value_accessor[line[1]] === second_number
            value_accessor[line[1]] = is_same ? 1 : 0
        else
            p "instruction #{line[0]} not found" unless line[0] === 'inp'
        end
        break if value_accessor['z'] > (10**6)*3
        # p value_accessor
    end
    # p value_accessor
    value_accessor
end

validate_model_number monad_data