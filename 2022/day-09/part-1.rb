require 'set'
require_relative '../helper'
include Helper

data = Helper::upload("2022/day-09/input.txt")
data_test = Helper::upload("2022/day-09/input-test-1.txt")


class Tail

    attr_accessor :position, :move_history

    def initialize
        @position = [0,0]
        @move_history = Set.new(["0,0"])
    end

    def touching? head
        x, y = @position
        (head[0] - x).abs < 2 && (head[1] - y).abs < 2
    end

    def move head
        return if touching? head
        difference = [head[0] - @position[0], head[1] - @position[1]]
        @position[0] += get_move(difference[0])
        @position[1] += get_move(difference[1])
        @move_history.add("#{@position[0]},#{@position[1]}")
        
    end

    private
    def get_move difference
        move = difference
        if difference > 1
            move = difference - 1
        elsif difference < -1
            move = difference + 1
        end
        move
    end
end

def calculate data

    head_position = [0,0]
    tail = Tail.new()

    data.each do |motion|
        direction, steps = motion.split(" ")
        steps.to_i.times do |n|
            head_position = get_head_position(head_position, direction)
            tail.move(head_position)
        end
    end

    p tail.move_history.size
end

def get_head_position position, direction
    x, y = position
    case direction
    when 'L'
        x -= 1
    when 'R'
        x += 1
    when 'U'
        y += 1
    when 'D'
        y -= 1
    else
        throw "Error: don't recognise direction instruction"
    end
    [x, y]
end

calculate data