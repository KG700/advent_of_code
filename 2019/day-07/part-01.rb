require_relative '../helper'
include Helper

opcode_data = Helper::upload("2019/day-07/input.txt")
opcode_data_test_1 = Helper::upload("2019/day-07/input-test-1.txt")
opcode_data_test_2 = Helper::upload("2019/day-07/input-test-2.txt")
opcode_data_test_3 = Helper::upload("2019/day-07/input-test-3.txt")

INITIAL_INPUT = 0
NUMBER_OF_PARAMETERS = {'01' => 3, '02' => 3, '03' => 1, '04' => 1, '05' => 2, '06' => 2, '07' => 3, '08' => 3, '99' => 0}

def computer opcodes
    opcodes_in_memory = opcodes[0].split(",").map(&:to_i)

    max_output = run_programme([], [0, 1, 2, 3, 4], opcodes_in_memory)
    p max_output
end

def run_programme phase_settings_in_use, phase_settings_to_use, opcodes
    max_output = 0
    if phase_settings_to_use.length > 0
        phase_settings_to_use.each do |setting|
            phase_settings = Helper::deep_copy(phase_settings_in_use)
            phase_settings.push(setting)
            phase_settings_not_used = Helper::deep_copy(phase_settings_to_use)
            phase_settings_not_used.delete(setting)
            output = run_programme(phase_settings, phase_settings_not_used, opcodes)
            max_output = [output, max_output].max
        end
    else
        input = INITIAL_INPUT
    
        5.times do |num|
            opcodes = Helper::deep_copy(opcodes)
            max_output = incode_computer(phase_settings_in_use[num], input, opcodes)
            input = max_output
        end
    end
    max_output
end

def incode_computer setting, input, opcodes
    inputs = [setting, input]
    input_number = 0
    next_instruction = 0
    
    loop do
        config = "00000#{opcodes[next_instruction]}"[-5..-1]
        instruction = config[3...5]
        num_params = NUMBER_OF_PARAMETERS[instruction]
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
                throw "Error: not enough inputs" if input_number > 1
                opcodes[parameters[0]] = inputs[input_number]
                input_number += 1
            when '04'
                return val_1
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
                throw "Error: instruction doesn't exist in programme"
        end
        
        break if next_instruction > opcodes.length
    end
end

computer opcode_data