require_relative '../helper'
include Helper

test_data = [
    "mask = 000000000000000000000000000000X1001X",
    "mem[42] = 100",
    "mask = 00000000000000000000000000000000X0XX",
    "mem[26] = 1"
]
mask_data = Helper::upload("2020/day-14/bit-mask-data.txt")

def sum_of_numbers_in_memory mask_data
    mask_data.map! { |data| data.split(" = ") }

    mask = ''
    memory = {}
    mask_data.each do |data|
        if data[0] == "mask"
            mask = data[1].split('')
        else
            data[0].slice!("mem[")
            data[0].slice!("]")
            binary_memory = data[0].to_i.to_s(2).rjust(36,"0").split('')
            binary_memory = binary_memory.each_with_index.map { |bit, index| bit = mask[index] != "0" ? mask[index] : bit  }
            binary_memories = getMemoryAddresses(binary_memory)
            binary_memories.each do |address|
                memory[address.join.to_i(2)] = data[1].to_i
            end
        end
    end
    sum = 0
    memory.each { |mem, val| sum += val }
    p sum
end

def getMemoryAddresses memory
    if memory.count('X') == 0
        addresses = []
        return addresses.push(memory) 
    end

    position = memory.index('X')
    memory_0 = memory[0..-1]
    memory_1 = memory[0..-1]
    memory_0[position] = 0
    memory_1[position] = 1

    addresses_0 = getMemoryAddresses(memory_0)
    addresses_1 = getMemoryAddresses(memory_1)

    return addresses_0.concat(addresses_1)

end

sum_of_numbers_in_memory mask_data
