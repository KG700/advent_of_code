require 'set'
require_relative '../helper'
include Helper

code_data = Helper::upload("day-19/code-data.txt")
test_1_data = [
    '0: 1 2',
    '1: "a"',
    '2: 1 3 | 3 1',
    '3: "b"',
    "",
    'aab',
    'aba',
    'bab',
    'bba'
]

test_2_data = [
    '0: 4 1 5',
    '1: 2 3 | 3 2',
    '2: 4 4 | 5 5',
    '3: 4 5 | 5 4',
    '4: "a"',
    '5: "b"',
    '',
    "ababbb",
    "bababa",
    "abbbab",
    "aaabbb",
    "aaaabbb"
]

def sea_monster data

    rules = {}
    letters = Set[]
    section = 'top'
    data.each do |row|
        case section
        when 'top'
            if row.empty?
                section = 'bottom'
                next
            end
            row_array = row.split(": ")
            values = row_array[1].split(" | ")
            values = values.map { |val| val.split(" ") }
            values[0][0] = values[0][0].tr('"', '') if values[0][0].is_a?(String)
            values = [["42"], ["42", "42"], ["42", "42", "42"]] if row_array[0] == "8"
            values = [["42", "31"], ["42", "42", "31", "31"], ["42", "42", "42", "31", "31", "31"]] if row_array[0] == "11"
            rules[row_array[0]] = values

        when 'bottom'
            letters.add(row)
        end
    end

    all_valid_letters = find_valid_letters('0', rules)
    valid_letters = letters & all_valid_letters
    valid_letters = letters.select { |string| all_valid_letters.include?(string) }
    p valid_letters.length

end

def find_valid_letters input, rules
    return input[0] if input.kind_of?(Array) && input[0][0] =~ /[[:alpha:]]/
    return find_valid_letters(rules[input], rules) if !input.kind_of?(Array)

    valid_letters = Set[]
    input.each do |codes|
        valid_strings = ['']
        codes.each do |code|
            letters = find_valid_letters(code, rules)
            strings = Marshal.load(Marshal.dump(valid_strings))
            valid_strings = []
            strings.each { |str| letters.each { |letter| valid_strings.push(str + letter) } }
        end
        valid_letters.merge(valid_strings)
    end
    return valid_letters
    
end

sea_monster(code_data)