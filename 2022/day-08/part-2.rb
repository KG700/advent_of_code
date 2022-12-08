require_relative '../helper'
include Helper

data = Helper::upload("2022/day-08/input.txt")
data_test = Helper::upload("2022/day-08/input-test.txt")

def calculate data
    trees = data.map { |tree_row| tree_row.chars.to_a.map { |tree| {height: tree.to_i, scenic: 1} } }

    2.times do |n|
        trees.each do |tree_row|
            (1...tree_row.length - 1).each do |left|
                right = tree_row.length - left - 1

                left_count = 0
                (left - 1).downto(0).each do |i|
                    left_count += 1
                    break if tree_row[i][:height] >= tree_row[left][:height]
                end

                right_count = 0
                ((right + 1)...tree_row.length).each do |i|
                    right_count += 1 
                    break if tree_row[i][:height] >= tree_row[right][:height]
                end

                tree_row[left][:scenic] *= left_count unless left_count == 0
                tree_row[right][:scenic] *= right_count unless right_count == 0
            end
        end
        trees = trees.transpose
    end

    top_scenic_score = trees.reduce(0) { |max, tree_row| max = tree_row.reduce(max) { |max, tree| max = tree[:scenic] > max ? tree[:scenic] : max }}

    p top_scenic_score
end

calculate data