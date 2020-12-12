require "set"

def number_of_yes_answers
    yes_data = upload("day-6/yes-data.txt")
    yes_group = []

    group_set = Set.new()
    yes_data.each do |individual|
        if individual.empty?
            yes_group.push(group_set.length)
            group_set = Set.new()
        else
            answers = individual.split("")
            answers.each { |answer| group_set.add(answer) }
        end
    end
    yes_group.push(group_set.length)
    p yes_group.inject(0){|sum,x| sum + x }
end

def upload file
    file = File.open(file)
    file_data = file.readlines.map(&:chomp)
    file.close
    file_data
end

number_of_yes_answers