require_relative '../helper'
include Helper

opcode_data = Helper::upload("2019/day-07/input.txt")
opcode_data_test_1 = Helper::upload("2019/day-07/input-test-1.txt")
opcode_data_test_2 = Helper::upload("2019/day-07/input-test-2.txt")
opcode_data_test_3 = Helper::upload("2019/day-07/input-test-3.txt")
opcode_data_test_4 = Helper::upload("2019/day-07/input-test-4.txt")
opcode_data_test_5 = Helper::upload("2019/day-07/input-test-5.txt")

INITIAL_INPUT = 0
NUMBER_OF_PARAMETERS = {'01' => 3, '02' => 3, '03' => 1, '04' => 1, '05' => 2, '06' => 2, '07' => 3, '08' => 3, '99' => 0}

def computer opcodes
    opcodes_in_memory = opcodes[0].split(",").map(&:to_i)

    max_output = run_programme([], [5, 6, 7, 8, 9], opcodes_in_memory)
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
        amplifiers = []
        5.times { |num| amplifiers.push(Amplifier.new(phase_settings_in_use[num], Helper::deep_copy(opcodes), num)) }
        amplifiers.each_with_index { |amplifier, index| amplifier.connect_to amplifiers[(index + 1) % 5] }
        amplifiers[0].update_amplifier(INITIAL_INPUT)
        max_output = amplifiers[4].output
    end
    
    max_output
end

class Amplifier

    attr_accessor :input, :connected, :has_halted, :output
    attr_reader :id

    def initialize setting, opcodes, index
        @id = index
        @inputs = [setting]
        @input_index = 0
        @output = nil
        @next_instruction = 0
        @opcodes = Helper::deep_copy(opcodes)
        @connected = nil
        @has_halted = false
    end

    def connect_to amplifier
        @connected = amplifier
    end

    def update_amplifier input
        @inputs.push(input)
        compute()
    end

    def compute
        
        loop do
            config = "00000#{@opcodes[@next_instruction]}"[-5..-1]
            instruction = config[3...5]
            num_params = NUMBER_OF_PARAMETERS[instruction]
            modes = [config[2], config[1], config[0]]
            parameters = @opcodes[(@next_instruction + 1)..(@next_instruction + num_params)]
            
            if num_params > 0
                val_1 = parameters[0]
                val_1 = @opcodes[val_1] if modes[0] == '0'
            end
            val_2 = 0
            
            if num_params > 1
                val_2 = parameters[1]
                val_2 = @opcodes[val_2] if modes[1] == '0'
            end
            
            @next_instruction += num_params + 1

            has_halted = false
            
            case instruction
            when '01'
                    @opcodes[parameters[2]] = val_1 + val_2
                when '02'
                    @opcodes[parameters[2]] = val_1 * val_2
                when '03'
                    throw "Error: 303: not enough inputs" if @input_index >= @inputs.length
                    @opcodes[parameters[0]] = @inputs[@input_index]
                    @input_index += 1
                when '04'
                    throw "Error: 403 : not enough inputs" if @input_index > @inputs.length
                    if @input_index == @inputs.length
                        @output = val_1
                        @connected.update_amplifier val_1 
                        break
                    end
                when '05'
                    @next_instruction = val_2 if val_1 != 0
                when '06'
                    @next_instruction = val_2 if val_1 == 0
                when '07'
                    @opcodes[parameters[2]] = val_1 < val_2 ? 1 : 0
                when '08'
                    @opcodes[parameters[2]] = val_1 == val_2 ? 1 : 0
                when '99'
                    has_halted = true
                else
                    throw "Error: instruction doesn't exist in programme"
            end

            break if has_halted
        end
    end
end

computer opcode_data