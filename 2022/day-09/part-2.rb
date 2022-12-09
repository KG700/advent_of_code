require 'set'
require_relative '../helper'
include Helper

data = Helper::upload("2022/day-09/input.txt")
data_test = Helper::upload("2022/day-09/input-test-2.txt")

class Knot

    attr_accessor :position, :move_history, :trailing

    def initialize knot = nil
        @position = [0,0]
        @move_history = Set.new(["0,0"])
        @trailing = knot
    end

    def update_position position
        @position = position
        @trailing.move position unless @trailing.nil?
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
        @trailing.move @position unless @trailing.nil?
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

    head = Knot.new(Knot.new())
    tail = Knot.new()

    knot = head.trailing
    8.times do |n| 
        if n == 7
            knot.trailing = tail
        else
            new_knot = Knot.new()
            
            knot.trailing = new_knot
            knot = new_knot
        end      
    end

    data.each do |motion|
        direction, steps = motion.split(" ")
        steps.to_i.times do |n|
            head.update_position(get_head_position(head.position, direction))
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