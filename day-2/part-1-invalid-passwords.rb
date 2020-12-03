# file = File.open("part-1-passwords.txt")
# file_data = file.readlines.map(&:chomp)
# file.close
# p file_data
counter = 0

file_data = File.foreach("input-passwords.txt") do |line| 
    line = line.split(" ")
    # p line
    element = line[0].split("-")
    # p element
    # p line[1]
    # p line[2]
    character_count = line[2].count(line[1][0])
    # p character_count
    if (character_count < element[0].to_i || character_count > element[1].to_i)
    else
        p line
        counter += 1
        p counter
        line.push(true)
    end
end
