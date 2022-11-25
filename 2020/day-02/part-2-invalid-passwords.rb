require_relative '../helper'
include Helper

file_data = Helper::upload("2020/day-02/input-passwords.txt")

counter = 0

file_data.each do |line| 
    line = line.split(" ")
    element = line[0].split("-")
    character_count = line[2].count(line[1][0])
    first_pos = line[2][element[0].to_i - 1] == line[1][0]
    sec_pos = line[2][element[1].to_i - 1] == line[1][0]
    counter += 1 if (first_pos || sec_pos) && (first_pos != sec_pos)
end
p counter
