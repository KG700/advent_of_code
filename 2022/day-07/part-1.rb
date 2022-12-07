require_relative '../helper'
include Helper

data = Helper::upload("2022/day-07/input.txt")
data_test = Helper::upload("2022/day-07/input-test.txt")

class Directory
    attr_reader :name, :parent, :type
    attr_accessor :items

    def initialize name, parent = nil
        @name = name
        @type = 'dir'
        @parent = parent
        @items = {}
        @sub_directories = []
        @files = []
    end

    def size
        directory_size = 0
        @items.each {|name, item| directory_size += item.size }
        directory_size
    end

    def add item
        @items[item.name] = item
        if item.type == 'dir'
            @sub_directories.push(item.name)
        else
            @files.push(item.name)
        end
    end

    def get_all_sub_directories
        @sub_directories.reduce([]) do |all_directories, name|
            directory = @items[name]
            all_directories.push(directory)
            directory.get_all_sub_directories.each { |sub_directory| all_directories.push(sub_directory) }
            all_directories
        end
    end

end

class File
    attr_reader :name, :size, :type

    def initialize name, size
        @name = name
        @size = size
        @type = 'file'
    end
end

def calculate data

    root_directory = Directory.new('root')

    current_directory = root_directory
    data.each do |line|
        if line[0] == '$'
            dollar, command, name = line.split(' ')
            if command == 'cd'
                case name
                when ".."
                    current_directory = current_directory.parent
                when "/"
                    current_directory = root_directory
                else
                    current_directory = current_directory.items[name]
                end
            end
        else
            info, name = line.split(' ')
            if info == 'dir'
                current_directory.add(Directory.new(name, current_directory))
            else
                current_directory.add(File.new(name, info.to_i))
            end
        end
    end

    total_size = root_directory.get_all_sub_directories.reduce(0) do |total, directory|
        total += directory.size <= 100000 ? directory.size : 0
    end

    p total_size
    
end

calculate data