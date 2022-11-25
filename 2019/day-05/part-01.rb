require_relative '../helper'
include Helper

opcode_data = Helper::upload("2019/day-05/input.txt")
# opcode_data_test = Helper::upload("2019/day-05/test-input.txt")

INPUT = 1

def computer opcodes
    opcodes = opcodes[0].split(",").map(&:to_i)

    next_instruction = 0
    
    loop do
        config = "00000#{opcodes[next_instruction]}"[-5..-1]
        instruction = config[3...5]
        num_params = instruction == '01' || instruction == '02' ? 3 : 1
        modes = [config[2], config[1], config[0]]
        modes
        parameters = opcodes[(next_instruction + 1)..(next_instruction + num_params)]

        val_1 = parameters[0]
        val_1 = opcodes[val_1] if modes[0] == '0'
        val_2 = 0

        if parameters.length > 1
            val_2 = parameters[1]
            val_2 = opcodes[val_2] if modes[1] == '0'
        end

        case instruction
            when '01'
                opcodes[parameters[2]] = val_1 + val_2
            when '02'
                opcodes[parameters[2]] = val_1 * val_2
            when '03'
                opcodes[parameters[0]] = INPUT
            when '04'
                p "output: #{opcodes[parameters[0]]}"
            when '99'
                break
            else
                throw "Error"
        end
        next_instruction += num_params + 1
        break if next_instruction > opcodes.length
    end
end

computer opcode_data