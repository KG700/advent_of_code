require_relative '../helper'
include Helper

data = Helper::upload("2023/day-02/input.txt")
data_test = Helper::upload("2023/day-02/input-test.txt")

LIMITS = { 'red' => 12, 'green' => 13, 'blue' => 14 }

def calculate data
    data.reduce(0) do |total, game|
        id, handfuls = game.split(': ')
        id = id.split(' ')[1].to_i
        
        impossible = handfuls.split('; ').select do |handful|
            handful.split(', ').select do |cube| 
                number, colour = cube.split(' ')
                number.to_i > LIMITS[colour]
            end.length > 0
        end
        
        total += impossible.length == 0 ? id : 0
    end
end

p calculate data