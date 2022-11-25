require_relative '../helper'
include Helper

monad_data = Helper::upload("2021/day-24/input.txt")
monad_data_test = Helper::upload("2021/day-24/test-input.txt")

def validate_model_number monad_data

    data = monad_data.map {|line| line.split(" ") }

    all_instructions = []
    indv_instuctions = []
    data.each do |line|
        if line[0] === 'inp'
            all_instructions.push(indv_instuctions) if indv_instuctions.length > 0
            indv_instuctions = [line]
        else
            indv_instuctions.push(line)
        end
    end
    all_instructions.push(indv_instuctions)

    index = 0
    value_accessor = {'w' => 0, 'x' => 0, 'y' => 0, 'z' => 0}

    result = calculate(all_instructions, value_accessor, index)

    p result[:number]

end

def calculate(data, value_accessor, index)
    result = {}

    9.downto(1) do |model_number|
        processing_unit = run_ALU(data[index], model_number, Helper::deep_copy(value_accessor))
        next if processing_unit["z"] > (10**6)*2.5005
        if data.length - 1 > index
            result = calculate(data, Helper::deep_copy(processing_unit), index + 1)
            result[:number] = "#{model_number}#{result[:number]}" if result[:valid]
        else
            is_valid = processing_unit['z'] === 0
            result = {valid: is_valid, number: is_valid ? "#{model_number.to_s}" : nil}
            p processing_unit
        end
        break if result[:valid]
    end
    result
end

def run_ALU(instructions, model_number, value_accessor)
    second_number = 0
    instructions.each_with_index do |line, index|
        second_number = value_accessor.key?(line[2]) ? value_accessor[line[2]] : line[2].to_i

        case line[0]
        when 'inp'
            value_accessor[line[1]] = model_number
        when 'add'
            value_accessor[line[1]] += second_number
        when 'mul'
            value_accessor[line[1]] *= second_number
        when 'div'
            if second_number != 0
                value_accessor[line[1]] /= second_number
            else
                p "Error: #{second_number} is zero. Can't divide"
            end
        when 'mod'
            if (value_accessor[line[1]] >= 0 && second_number > 0)
                value_accessor[line[1]] %= second_number
            else
                p "Error:#{value_accessor[line[1]]} or #{second_number} is less than zero. Can't do modulo"
            end
        when 'eql'
            is_same = value_accessor[line[1]] === second_number
            value_accessor[line[1]] = is_same ? 1 : 0
        else
            p "instruction #{line[0]} not found" unless line[0] === 'inp'
        end
    end
    value_accessor
end

validate_model_number monad_data