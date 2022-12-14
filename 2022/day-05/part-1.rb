require_relative '../helper'
include Helper

data = Helper::upload_line_break("2022/day-05/input.txt")
data_test = Helper::upload_line_break("2022/day-05/input-test.txt")

def calculate data
    creates_map, steps = data.map { |section| section.split(/\n/) }
    labels, *crates = creates_map.reverse
    stacks = {}

    (1..labels.length).step(4) do |i|
        stacks[labels[i]] = ""
        crates.each { |crate| stacks[labels[i]] += crate[i] unless crate[i] == " " }
    end

    steps.each do |step|
        move, from, to = step.scan(/move (.*) from (.*) to (.*)/).first

        move.to_i.times do |crate|
            crate_to_move = stacks[from].slice!(-1)
            stacks[to] += crate_to_move
        end
    end

    top_of_stacks = ""
    stacks.each { |label, stack| top_of_stacks += stack[-1] }
    p top_of_stacks

end

calculate data