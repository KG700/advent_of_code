require_relative '../helper'
include Helper

hex_data = Helper::upload("day-16/input.txt")
hex_data_test_1 = Helper::upload("day-16/test-input-1.txt")
hex_data_test_2 = Helper::upload("day-16/test-input-2.txt")
hex_data_test_3 = Helper::upload("day-16/test-input-3.txt")
hex_data_test_4 = Helper::upload("day-16/test-input-4.txt")
hex_data_test_5 = Helper::upload("day-16/test-input-5.txt")
hex_data_test_6 = Helper::upload("day-16/test-input-6.txt")
hex_data_test_7 = Helper::upload("day-16/test-input-7.txt")

HEX_TO_BIN = {
    "0" => "0000",
    "1" => "0001",
    "2" => "0010",
    "3" => "0011",
    "4" => "0100",
    "5" => "0101",
    "6" => "0110",
    "7" => "0111",
    "8" => "1000",
    "9" => "1001",
    "A" => "1010",
    "B" => "1011",
    "C" => "1100",
    "D" => "1101",
    "E" => "1110",
    "F" => "1111"
}

# BIN_TO_DEC = {
#     "001" => 1,
#     "010" => 2,
#     "011" => 3,
#     "100" => 4,
#     "101" => 5,
#     "110" => 6,
#     "111" => 7
# }

def find_version hex_data
    
    bin_data = hex_data[0].split("").map {|char| HEX_TO_BIN[char] }.join

    packet_versions, extra_bits = packet_version(bin_data)

    p packet_versions.sum

end

def packet_version(bin_string)
    return [[], ""] if bin_string.nil? || bin_string.to_i == 0 || bin_string.length < 6

    version = Helper::to_decimal(bin_string[(0..2)])
    type_Id = Helper::to_decimal(bin_string[(3..5)])
    the_rest = bin_string[(6..-1)]
    subpackets = []
    extra_bits = ""

    if type_Id === 4
        subpacket, extra_bits = find_literal_packet_version(the_rest)
        
    elsif
        length_type_ID = the_rest[0]
        if length_type_ID === "0"
            subpackets_length = Helper::to_decimal(the_rest[1..(15)])
            subpackets_string = the_rest[16...(16 + subpackets_length)]
            extra_bits = the_rest[(16 + subpackets_length)..-1]
            subpackets = []
            subpackets_string_tail = subpackets_string

            until subpackets_string_tail === "" do
                subpacket_from_loop, subpackets_string_tail = packet_version(subpackets_string)
                subpacket_from_loop.each {|subpacket| subpackets.push(subpacket)}
                subpackets_string = subpackets_string_tail
            end
        else
            packet_number = Helper::to_decimal(the_rest[1..(11)])
            subpackets_string = the_rest[12..-1]

            packet_number.times do |n|
                subpackets_from_section, extra_bits = packet_version(subpackets_string)
                subpackets_string = extra_bits
                subpackets_from_section.each {|packet| subpackets.push(packet)}
            end

        end

    end

    packet_versions = subpackets.push(version)

    [packet_versions, extra_bits]

end

def find_literal_packet_version bin_string
    packet = ""
    n = 0
    loop do
        packet += bin_string[((n+1)..(n+4))]
        break if bin_string[n] === "0" || n > bin_string.length
        n += 5
    end

    the_rest = bin_string[(n + 5)..-1]

    [packet, the_rest]

end

find_version hex_data
