require_relative '../helper'
include Helper

opcode_data = Helper::upload("2019/day-02/input.txt")
opcode_data_test = Helper::upload("2019/day-02/test-input.txt")

REQUIRED_OUTPUT = 19690720

def computer opcodes
    opcodes_in_memory = opcodes[0].split(",").map(&:to_i)
    
    (0..99).each do |noun|
        (0..99).each do |verb|
            opcodes = Helper::deep_copy(opcodes_in_memory)
            opcodes[1] = noun
            opcodes[2] = verb

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
            if opcodes[0] == REQUIRED_OUTPUT
                p 100 * noun + verb
                break
            end
        end
        break if opcodes[0] == REQUIRED_OUTPUT
    end  
end

computer opcode_data