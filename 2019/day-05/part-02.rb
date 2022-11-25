require_relative '../helper'
include Helper

opcode_data = Helper::upload("2019/day-05/input.txt")
opcode_data_test_1 = Helper::upload("2019/day-05/test-input-1.txt")
opcode_data_test_2 = Helper::upload("2019/day-05/test-input-2.txt")
opcode_data_test_3 = Helper::upload("2019/day-05/test-input-3.txt")

INPUT = 5

def computer opcodes
    opcodes = opcodes[0].split(",").map(&:to_i)
    num_params_map = {'01' => 3, '02' => 3, '03' => 1, '04' => 1, '05' => 2, '06' => 2, '07' => 3, '08' => 3, '99' => 0}

    next_instruction = 0
    
    loop do
        config = "00000#{opcodes[next_instruction]}"[-5..-1]
        instruction = config[3...5]
        num_params = num_params_map[instruction]
        modes = [config[2], config[1], config[0]]
        parameters = opcodes[(next_instruction + 1)..(next_instruction + num_params)]

        if num_params > 0
            val_1 = parameters[0]
            val_1 = opcodes[val_1] if modes[0] == '0'
        end
        val_2 = 0

        if num_params > 1
            val_2 = parameters[1]
            val_2 = opcodes[val_2] if modes[1] == '0'
        end

        next_instruction += num_params + 1

        case instruction
            when '01'
                opcodes[parameters[2]] = val_1 + val_2
            when '02'
                opcodes[parameters[2]] = val_1 * val_2
            when '03'
                opcodes[parameters[0]] = INPUT
            when '04'
                p "output: #{val_1}"
            when '05'
                next_instruction = val_2 if val_1 != 0
            when '06'
                next_instruction = val_2 if val_1 == 0
            when '07'
                opcodes[parameters[2]] = val_1 < val_2 ? 1 : 0
            when '08'
                opcodes[parameters[2]] = val_1 == val_2 ? 1 : 0
            when '99'
                break
            else
                throw "Error"
        end
        
        break if next_instruction > opcodes.length
    end
end

computer opcode_data