require_relative '../helper'
include Helper

file_data = Helper::upload("day-2/input-passwords.txt")

counter = 0

file_data.each do |line| 
    line = line.split(" ")
    element = line[0].split("-")
    character_count = line[2].count(line[1][0])
    if (character_count < element[0].to_i || character_count > element[1].to_i)
    else
        counter += 1
    end
end

p counter
