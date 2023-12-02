require_relative '../helper'
include Helper

data = Helper::upload("2023/day-02/input.txt")
data_test = Helper::upload("2023/day-02/input-test.txt")

def calculate data
    data.reduce(0) do |total, game|
        handfuls = game.split(': ')[1].split('; ')
        minimums = { 'red' => 0, 'green' => 0, 'blue' => 0 }

        handfuls.each do |handful|
            handful.split(',').each do |cube|
                number, colour = cube.split(' ')
                minimums[colour] = number.to_i if number.to_i > minimums[colour]
            end
        end

        total + minimums.reduce(1) { |powers, (colour, min)| powers * min }
    end
end

p calculate data