require_relative '../helper'
include Helper

# data = Helper::upload("2023/day-06/input.txt")
# data_test = Helper::upload("2023/day-06/input-test.txt")

data = [[46, 80, 78, 66], [214, 1177, 1402, 1024]]
data_test = [[7, 15, 30], [9, 40, 200]]

def calculate data
    time, distance = data

    multiplied = 1
    time.each_with_index do |n, index|
        epsilone = 0.0001
        low = (-n + Math.sqrt(n**2 - 4*(-1)*(-distance[index]))) / -2
        high = (-n - Math.sqrt(n**2 - 4*(-1)*(-distance[index]))) / -2

        multiplied *= (high - epsilone).floor - (low + epsilone).ceil + 1
    end
    multiplied
end

p calculate data