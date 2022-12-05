require_relative '../helper'
include Helper

data = Helper::upload_line_break("2022/day-05/input.txt")
data_test = Helper::upload_line_break("2022/day-05/input-test.txt")

def calculate data
    data.map! { |section| section.split(/\n/) }
    labels, *crates = data[0].reverse
    stacks = {}

    (1..labels.length).step(4) do |i|
        stacks[labels[i]] = []
        crates.each { |crate| stacks[labels[i]].push(crate[i]) unless crate[i] == " " }
    end

    data[1].each do |step|
        move, from, to = step.scan(/move (.*) from (.*) to (.*)/).first
        move.to_i.times do |crate|
            crate_to_move = stacks[from].pop()
            stacks[to].push(crate_to_move)
        end
    end
    top_of_stacks = ""
    stacks.each { |label, stack| top_of_stacks += stack.last }
    p top_of_stacks

end

calculate data