require_relative '../helper'
include Helper

opcode_data = Helper::upload("2019/day-02/input.txt")
opcode_data_test = Helper::upload("2019/day-02/test-input.txt")

def computer opcodes
    opcodes = opcodes[0].split(",").map(&:to_i)
    
    opcodes[1] = 12
    opcodes[2] = 2

    opcodes.each_slice(4) do |opcode_step|
        position_0, position_1, position_2, position_3 = opcode_step
        case position_0
            when 1
                opcodes[position_3] = opcodes[position_1] + opcodes[position_2]
            when 2
                opcodes[position_3] = opcodes[position_1] * opcodes[position_2]
            when 99
                break
            else
                throw "Error"
        end
    end

    p opcodes[0]
    
end

computer opcode_data