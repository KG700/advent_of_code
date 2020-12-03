# file = File.open("part-1-passwords.txt")
# file_data = file.readlines.map(&:chomp)
# file.close
# p file_data
counter = 0

file_data = File.foreach("input-passwords.txt") do |line| 
    line = line.split(" ")
    element = line[0].split("-")
    character_count = line[2].count(line[1][0])
    p line[2][element[0].to_i]
    first_pos = line[2][element[0].to_i - 1] == line[1][0]
    sec_pos = line[2][element[1].to_i - 1] == line[1][0]
    if (first_pos || sec_pos)
        if (first_pos != sec_pos)
            counter += 1
        end
    end
    p counter
end
