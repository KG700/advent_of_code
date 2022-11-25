require "set"
require_relative '../helper'
include Helper

path_data = Helper::upload("2021/day-12/part-1-input.txt")
path_test0_data = Helper::upload("2021/day-12/test-input-0.txt")
path_test1_data = Helper::upload("2021/day-12/test-input-1.txt")
path_test2_data = Helper::upload("2021/day-12/test-input-2.txt")

def find_paths path_data
    path_nodes = Hash.new {|h,k| h[k] = []}
    
    path_data.each do |node| 
        node_array = node.split("-")
        path_nodes[node_array[0]].push(node_array[1])
        path_nodes[node_array[1]].push(node_array[0])
    end

    current_path = ["start"]
    level = 1

    paths = find_all_paths("start", current_path, level, path_nodes, Set[])
   
    p paths.length

end

def find_all_paths(cave, current_path, level, path_nodes, all_paths)
    level_paths = []
    path_nodes[cave].each do |next_cave|
        to_add = true
        to_add = false if next_cave === "start" || (next_cave === next_cave.downcase && current_path.include?(next_cave))
        current_path = current_path.first(level).push(next_cave) if to_add

        level_paths.push(current_path) if current_path[-1] === "end"
        all_paths = find_all_paths(next_cave, current_path, level + 1, path_nodes, all_paths) if to_add && current_path[-1] != "end"
        level_paths.each {|path| all_paths.add(path)} if level_paths.length > 0
    end
    all_paths
end

find_paths path_data