require "set"
require_relative '../helper'
include Helper

def number_of_yes_answers
    yes_data = Helper::upload("2020/day-06/yes-data.txt")
    yes_group = []

    number_in_group = 0
    group_set = Set.new()
    group_array = []
    yes_data.each do |individual|
        if individual.empty?
            yes_group.push(count_answers group_set, group_array, number_in_group)
            group_set = Set.new()
            number_in_group = 0
            group_array = []
        else
            answers = individual.split("")
            group_array.push(answers)
            answers.each { |answer| group_set.add(answer) }
            number_in_group += 1
        end
    end
    yes_group.push(count_answers group_set, group_array, number_in_group)
    p yes_group.inject(0){|sum,x| sum + x }
end

def count_answers set, array, number
    count = 0
    set.each { |answer| count += 1 if array.flatten.count(answer) == number }
    count
end

number_of_yes_answers