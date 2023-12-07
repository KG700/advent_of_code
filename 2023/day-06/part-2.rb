require_relative '../helper'
include Helper

# data = Helper::upload("2023/day-06/input.txt")
# data_test = Helper::upload("2023/day-06/input-test.txt")

data = [[46807866], [214117714021024]]
data_test = [[71530], [940200]]

def calculate data
    time, distance = data

    time.each_with_index do |n, index|
        epsilone = 0.0001
        low = (-n + Math.sqrt(n**2 - 4*(-1)*(-distance[index]))) / -2
        high = (-n - Math.sqrt(n**2 - 4*(-1)*(-distance[index]))) / -2

        return (high - epsilone).floor - (low + epsilone).ceil + 1
    end
end

p calculate data