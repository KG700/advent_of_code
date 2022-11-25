require_relative '../helper'
include Helper

seqment_data = Helper::upload("2021/day-08/part-1-input.txt")
# seqment_test_data = Helper::upload("2021/day-08/test-input.txt")

DIGITS = {
    "123567" => 0,
    "36" => 1,
    "13457" => 2,
    "13467" => 3,
    "2346" => 4,
    "12467" => 5,
    "124567" => 6,
    "136" => 7,
    "1234567" => 8,
    "123467" => 9
}

def decode_seqments seqment_data
    seqment_data = seqment_data.map { |seq| seq.split(" | ").map { |digit| digit.split(" ") }}
    decoded_digits = seqment_data.map do |seq|
        positions = find_positions seq[0]
        sorted_digits = seq[1].map {|digit| digit.split("").map {|d| positions[d]}.sort.join}
        decoded_digit = sorted_digits.map {|digit| DIGITS[digit]}.join.to_i
    end
    p decoded_digits.reduce(0) {|sum, digit| sum + digit}
end

def find_positions sequence
    positions = {"a" => nil, "b" => nil, "c" => nil, "d" => nil, "e" => nil, "f" => nil, "g" => nil}
    known_digits = Hash.new
    digits_with_length_6 = []

    sequence.each do |digit| 
        case digit.length
        when 2
            known_digits[1] = digit.split("")
        when 3
            known_digits[7] = digit.split("")
        when 4
            known_digits[4] = digit.split("")
        when 7
            known_digits[8] = digit.split("")
        when 6
            digits_with_length_6.push(digit.split(""))
        else
            "not known"
        end
    end

    known_digits[6] = digits_with_length_6.select { |digit| ((known_digits[8] - digit) & known_digits[1]).length > 0 }[0]
    known_digits[0] = digits_with_length_6.select { |digit| ((known_digits[6] - digit) & known_digits[4]).length == 1 }[0]
    known_digits[9] = digits_with_length_6.select { |digit| ((known_digits[6] - digit) & (known_digits[0] - digit)).length == 1 }[0]
    
    position_1 = known_digits[7] - known_digits[1]
    position_3 = known_digits[8] - known_digits[6]
    position_4 = known_digits[8] - known_digits[0]
    position_5 = known_digits[8] - known_digits[9]
    position_6 = known_digits[1] - position_3
    position_2 = known_digits[4] - known_digits[1] - position_4
    position_7 = known_digits[8] - position_1 - position_2 - position_3 - position_4 - position_5 - position_6
    
    positions[position_1[0]] = 1
    positions[position_2[0]] = 2
    positions[position_3[0]] = 3
    positions[position_4[0]] = 4
    positions[position_5[0]] = 5
    positions[position_6[0]] = 6
    positions[position_7[0]] = 7
    
    positions
end

decode_seqments seqment_data