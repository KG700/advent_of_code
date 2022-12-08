require_relative '../helper'
include Helper

data = Helper::upload("2022/day-08/input.txt")
data_test = Helper::upload("2022/day-08/input-test.txt")

def calculate data
    trees = data.map { |tree_row| tree_row.chars.to_a.map { |tree| {height: tree.to_i, visible: false} } }

    2.times do |n|
        trees.each_with_index do |tree_row, i|
            tree_row.first[:visible] = true
            tree_row.last[:visible] = true

            left_max = tree_row.first[:height]
            right_max = tree_row.last[:height]
            
            (1..tree_row.length - 1).each do |left|
                right = tree_row.length - left - 1
                if tree_row[left][:height] > left_max
                    tree_row[left][:visible] = true
                    left_max = tree_row[left][:height]
                end
                if tree_row[right][:height] > right_max
                    tree_row[right][:visible] = true
                    right_max = tree_row[right][:height]
                end
            end
        end
        trees = trees.transpose
    end
    
    visible_trees = trees.reduce(0) { |count, tree_row| count += tree_row.select {|tree| tree[:visible] }.length }

    p visible_trees
end

calculate data