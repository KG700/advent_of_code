require 'set'
require_relative '../helper'
include Helper

reboot_data = Helper::upload("day-22/input.txt")
reboot_data_test_1 = Helper::upload("day-22/test-input-1.txt")
reboot_data_test_2 = Helper::upload("day-22/test-input-2.txt")
reboot_data_test_3 = Helper::upload("day-22/test-input-3.txt")
reboot_data_test_4 = Helper::upload("day-22/test-input-4.txt")

COORDS = ["x", "y", "z"]

def perform_reboot_steps reboot_data
    start = Time.now

    steps = reboot_data.map {|step| step.split(" ")}.map {|step| [step[0], step[1].split(",").map {|range| range[/[^=]*$/].split("..").map(&:to_i)}] }
   
    # cuboids = {range_list: []Ug, [x, y]: {range_list: [], [w,z]: {range_list: []}}}
    cuboids = {node: 'x', range_list: []}

    # range_list = cuboids[:range_list] || []
    steps.reverse.each do |step|
        # p step
       cuboids = update_cuboid(step, Helper::deep_copy(cuboids), 0)
    #    p cuboids
    #    p "-------"
    end

    # p cuboids[:range_list]
    on_count = 0
    # off_count = 0
    cuboids[:range_list].each do |x|
        x_count = x[1] - x[0] + 1
        cuboids[x][:range_list].each do |y|
            y_count = y[1] - y[0] + 1
            cuboids[x][y][:range_list].each do |z|
                # p cuboids[x][y][z]
                z_count = z[1] - z[0] + 1
                if cuboids[x][y][z][:is_on]
                    on_count += (x_count * y_count * z_count)
                # else
                #     off_count += (x_count * y_count * z_count)
                end
            end
        end
    end

    p on_count
    # p off_count

end

def update_cuboid step, cuboids, node
    # p "-----"
    # p step[0] if node == 1
    # p "node: #{node}"
    # p "step: #{step[1][node]}"
    # p cuboids
    range_list = Helper::deep_copy(cuboids[:range_list])
    # p "range_list: #{range_list}"

    new_node = create_node(step, node)
    # p "new z node: #{new_node}" if node == 2
    # p "new y node: #{new_node}" if node == 1
       
    if node < 2
        overlap_ranges, range_list = get_overlap_ranges(range_list, step[1][node])
        # p range_list
        # p "overlap_ranges #{overlap_ranges}"

        overlap_ranges.each do |range, info|
            saved_info = Helper::deep_copy(cuboids[range])
            cuboids.delete(range)
            info[:all_ranges].each {|range| cuboids[range] = Helper::deep_copy(saved_info)}
            update_cuboids = {}
                updated_cuboids = update_cuboid(step, Helper::deep_copy(cuboids[info[:overlap]]), node + 1) 
                cuboids[info[:overlap]] = updated_cuboids           
            # else
            #     info[:all_ranges].each {|range| cuboids[range] = {is_on: step[0] == 'on'} if range != info[:overlap]}
            #     cuboids[info[:overlap]] = {is_on: step[0] == 'on'}
            # p "z : #{cuboids}" if node == 2
            # p "y : #{cuboids}" if node == 1
        end
    end

    no_overlap_ranges, range_list = get_no_overlap_ranges(Helper::deep_copy(range_list), step[1][node])
    # p "after get_no_overlap_ranges"
    # p range_list
    # p "no_overlap_ranges #{no_overlap_ranges}"


    no_overlap_ranges.each do |range|
        cuboids[range] = Helper::deep_copy(new_node)
    end

    cuboids[:range_list] = Helper::deep_copy(range_list)
    # p cuboids if node == 0
    
    # p "----"
    Helper::deep_copy(cuboids)
end

# 

# def update_range_list list range
#     return range if list.length == 0
#     new_list = []
#     new_list
# end

def create_node step, node
    # z = {range_list: [step[1][2]], step[1][2] => {is_on: step[0] == 'on'}}
    # return z if node == 2
    z = {is_on: step[0] == 'on'}
    return z if node == 2
    y = {node: 'z', range_list: [step[1][2]], step[1][2] => z }
    return y if node == 1
    x = {node: 'y', range_list: [step[1][1]], step[1][1] => y }
    return x
end

def get_overlap_ranges list, new_range
    # p "overlap range is: #{list}"
    # p "new_range: #{new_range}"
    ranges = []
    overlap_ranges = {}

    list.each do |range|
        overlap = nil
        outside_range_1 = nil
        outside_range_2 = nil
        if new_range[0] > range[1] || new_range[1] < range[0]
            ranges.push(range)
        elsif range[0] <= new_range[0] && range[1] <= new_range[1]
            overlap = [new_range[0], range[1]]
            outside_range_1 = range[0] < new_range[0] ? [range[0], new_range[0] - 1] : nil
        elsif range[0] <= new_range[0] && range[1] >= new_range[1]
            overlap = new_range
            outside_range_1 = [range[0], new_range[0] - 1]
            outside_range_2 = [new_range[1] + 1, range[1]]
        elsif range[0] >= new_range[0] && range[1] <= new_range[1]
            overlap = range
        elsif range[0] >= new_range[0] && range[1] >= new_range[1]
            overlap = [range[0], new_range[1]]
            outside_range_2 = range[1] > new_range[1] ? [new_range[1] + 1, range[1]] : nil
        end

        all_ranges = []
        all_ranges.push(outside_range_1) if outside_range_1
        all_ranges.push(overlap) if overlap
        all_ranges.push(outside_range_2) if outside_range_2
        overlap_ranges[range] = {overlap: overlap, all_ranges: all_ranges} if overlap
        all_ranges.each {|range| ranges.push(range)}
    end

    # p "overlap_ranges: #{overlap_ranges}" 
    # p "ranges: #{ranges}"
    # p "-----"

    return [overlap_ranges, ranges]
end

def get_no_overlap_ranges list, new_range
    # p "list is: #{list}"
    # p "new_range: #{new_range}"
    ranges = []
    no_overlap_ranges = []

    sub_range = list.length > 0 ? [list[0][0], new_range[0]].min : new_range[0]

    list.each do |range|
        # p "range is: #{range}"
        if sub_range > new_range[1]
            # p 1
            ranges.push(range)
        elsif sub_range >= new_range[0]
            # p 2
            if sub_range == range[0]
                add_range = []
            elsif range[0] <= new_range[1]
                # p 21
                add_range = [sub_range, range[0] - 1]
            # elsif sub_range < range[0] && sub_range <= new_range[1] && range[1]
            #     p 22
            #     add_range = [sub_range, new_range[1]]
            else
                # p 22
                add_range = [sub_range, new_range[1]]
            end
            no_overlap_ranges.push(add_range) if add_range.length > 0
            ranges.push(add_range) if add_range.length > 0
            ranges.push(range)
            sub_range = range[1] + 1
        else
            if range[0] > new_range[1]
                # p 31
                add_range = new_range
            elsif range[0] > new_range[0]
                # p 32
                add_range = [new_range[0], range[0] - 1]
            else
                # p 33
                add_range = []
            end
            no_overlap_ranges.push(add_range) if add_range.length > 0
            ranges.push(add_range) if add_range.length > 0
            ranges.push(range)
            sub_range = range[1] + 1
        # else
        #     p 4
        #     ranges.push(range)
        #     sub_range = range[1] + 1
        end
    end

    if ranges.length == 0 || ranges.last[1] < new_range[1]
        # p 5
        last_range = []
        if ranges.length == 0 || ranges.last[1] < new_range[0]
            # p 51
            last_range = new_range
        else
            # p 52
            last_range = [ranges.last[1] + 1, new_range[1]]
        end
        no_overlap_ranges.push(last_range)
        ranges.push(last_range)
    end
    # p "no_overlap_ranges: #{no_overlap_ranges}" 
    # p "ranges: #{ranges}"
    # p "-----"

    return [no_overlap_ranges, ranges]
end


perform_reboot_steps reboot_data


def test_no_overlap()

    list = [[5,9]]
    new_range = [1,2]
    no_overlap_ranges, updated_list = get_no_overlap_ranges(list, new_range)
    p "new range: #{new_range}"
    p "list: #{list}"
    p "no_overlap_ranges #{no_overlap_ranges}, expected: #{[[1,2]]} #{no_overlap_ranges == [[1,2]]}"
    p "updated_list #{updated_list}, expected: #{[[1,2],[5,9]]} #{updated_list == [[1,2],[5,9]]}"
    p "-----"

    list = [[5,9]]
    new_range = [11,12]
    no_overlap_ranges, updated_list = get_no_overlap_ranges(list, new_range)
    p "new range: #{new_range}"
    p "list: #{list}"
    p "no_overlap_ranges #{no_overlap_ranges}, expected: #{[[11,12]]} #{no_overlap_ranges == [[11,12]]}"
    p "updated_list #{updated_list}, expected: #{[[5,9], [11,12]]} #{updated_list == [[5,9], [11,12]]}"
    p "-----"

    list = [[1,2], [5,9]]
    new_range = [11,12]
    no_overlap_ranges, updated_list = get_no_overlap_ranges(list, new_range)
    p "new range: #{new_range}"
    p "list: #{list}"
    p "no_overlap_ranges #{no_overlap_ranges}, expected: #{[[11,12]]} #{no_overlap_ranges == [[11,12]]}"
    p "updated_list #{updated_list}, expected: #{[[1,2], [5,9], [11,12]]} #{updated_list == [[1,2], [5,9], [11,12]]}"
    p "-----"

    list = [[0,2], [5,9]]
    new_range = [1,3]
    no_overlap_ranges, updated_list = get_no_overlap_ranges(list, new_range)
    p "new range: #{new_range}"
    p "list: #{list}"
    p "no_overlap_ranges #{no_overlap_ranges}, expected: #{[[3,3]]} #{no_overlap_ranges == [[3,3]]}"
    p "updated_list #{updated_list}, expected: #{[[0,2],[3,3],[5,9]]} #{updated_list == [[0,2],[3,3],[5,9]]}"
    p "-----"

    list = [[0,1], [5,9]]
    new_range = [1,2]
    no_overlap_ranges, updated_list = get_no_overlap_ranges(list, new_range)
    p "new range: #{new_range}"
    p "list: #{list}"
    p "no_overlap_ranges #{no_overlap_ranges}, expected: #{[[2,2]]} #{no_overlap_ranges == [[2,2]]}"
    p "updated_list #{updated_list}, expected: #{[[0,1],[2,2],[5,9]]} #{updated_list == [[0,1],[2,2],[5,9]]}"
    p "-----"

    list = [[5,9], [11,12]]
    new_range = [2,16]
    no_overlap_ranges, updated_list = get_no_overlap_ranges(list, new_range)
    p "new range: #{new_range}"
    p "list: #{list}"
    p "no_overlap_ranges #{no_overlap_ranges}, expected: #{[[2,4], [10,10], [13,16]]} #{no_overlap_ranges == [[2,4], [10,10], [13,16]]}"
    p "updated_list #{updated_list}, expected: #{[[2,4], [5,9], [10, 10], [11, 12], [13, 16]]} #{updated_list == [[2,4], [5,9], [10, 10], [11, 12], [13, 16]]}"
    p "-----"

    list = [[9, 9], [10, 10], [11, 11]]
    new_range =  [11, 13]
    no_overlap_ranges, updated_list = get_no_overlap_ranges(list, new_range)
    p "new range: #{new_range}"
    p "list: #{list}"
    p "no_overlap_ranges #{no_overlap_ranges}, expected: #{[[12, 13]]} #{no_overlap_ranges == [[12, 13]]}"
    p "updated_list #{updated_list}, expected: #{[[9, 9], [10, 10], [11,11], [12, 13]]} #{updated_list == [[9, 9], [10, 10], [11,11], [12, 13]]}"
    p "-----"

    list = [[9, 9], [10, 10], [11, 11], [12, 13]]
    new_range =  [10, 12]
    no_overlap_ranges, updated_list = get_no_overlap_ranges(list, new_range)
    p "new range: #{new_range}"
    p "list: #{list}"
    p "no_overlap_ranges #{no_overlap_ranges}, expected: #{[]} #{no_overlap_ranges == []}"
    p "updated_list #{updated_list}, expected: #{[[9, 9], [10, 10], [11, 11], [12, 13]]} #{updated_list == [[9, 9], [10, 10], [11, 11], [12, 13]]}"
    p "-----"

    list = [[9, 11]]
    new_range =  [10, 12]
    no_overlap_ranges, updated_list = get_no_overlap_ranges(list, new_range)
    p "new range: #{new_range}"
    p "list: #{list}"
    p "no_overlap_ranges #{no_overlap_ranges}, expected: #{[[12, 12]]} #{no_overlap_ranges == [[12, 12]]}"
    p "updated_list #{updated_list}, expected: #{[[9, 11], [12, 12]]} #{updated_list == [[9, 11], [12, 12]]}"
    p "-----"

    list = [[-46, -34], [40, 50]]
    new_range =  [-31, 22]
    no_overlap_ranges, updated_list = get_no_overlap_ranges(list, new_range)
    p "new range: #{new_range}"
    p "list: #{list}"
    p "no_overlap_ranges #{no_overlap_ranges}, expected: #{[[-31, 22]]} #{no_overlap_ranges == [[-31, 22]]}"
    p "updated_list #{updated_list}, expected: #{[[-46, -34], [-31, 22], [40, 50]]} #{updated_list == [[-46, -34], [-31, 22], [40, 50]]}"
    p "-----"

    list = [[-33, 15], [35, 39], [40, 47]]
    new_range =  [26, 39]
    no_overlap_ranges, updated_list = get_no_overlap_ranges(list, new_range)
    p "new range: #{new_range}"
    p "list: #{list}"
    p "no_overlap_ranges #{no_overlap_ranges}, expected: #{[[26, 34]]} #{no_overlap_ranges == [[26, 34]]}"
    p "updated_list #{updated_list}, expected: #{[[-33, 15], [26, 34], [35, 39], [40, 47]]} #{updated_list == [[-33, 15], [26, 34], [35, 39], [40, 47]]}"
    p "-----"
end

def test_overlap
    list = [[5,9]]
    new_range = [1,2]
    overlap_ranges, updated_list = get_overlap_ranges(list, new_range)
    p "new range: #{new_range}"
    p "list: #{list}"
    p "overlap_ranges #{overlap_ranges}, expected: #{{}} #{overlap_ranges == {}}"
    p "updated_list #{updated_list}, expected: #{[[5,9]]} #{updated_list == [[5,9]]}"
    p "-----"

    list = [[5,9]]
    new_range = [11,12]
    overlap_ranges, updated_list = get_overlap_ranges(list, new_range)
    p "new range: #{new_range}"
    p "list: #{list}"
    p "overlap_ranges #{overlap_ranges}, expected: #{{}} #{overlap_ranges == {}}"
    p "updated_list #{updated_list}, expected: #{[[5,9]]} #{updated_list == [[5,9]]}"
    p "-----"

    list = [[1,2], [5,9]]
    new_range = [11,12]
    overlap_ranges, updated_list = get_overlap_ranges(list, new_range)
    p "new range: #{new_range}"
    p "list: #{list}"
    p "overlap_ranges #{overlap_ranges}, expected: #{{}} #{overlap_ranges == {}}"
    p "updated_list #{updated_list}, expected: #{[[1,2], [5,9]]} #{updated_list == [[1,2], [5,9]]}"
    p "-----"

    list = [[0,2], [5,9]]
    new_range = [1,3]
    overlap_ranges, updated_list = get_overlap_ranges(list, new_range)
    p "new range: #{new_range}"
    p "list: #{list}"
    expected_overlap = {[0,2] => {overlap: [1,2], all_ranges: [[0,0], [1,2]]}}
    p "overlap_ranges #{overlap_ranges}, expected: #{expected_overlap} #{overlap_ranges == expected_overlap}"
    p "updated_list #{updated_list}, expected: #{[[0,0],[1,2],[5,9]]} #{updated_list == [[0,0],[1,2],[5,9]]}"
    p "-----"

    list = [[0,1], [5,9]]
    new_range = [1,2]
    overlap_ranges, updated_list = get_overlap_ranges(list, new_range)
    p "new range: #{new_range}"
    p "list: #{list}"
    expected_overlap = {[0,1] => {overlap: [1, 1], all_ranges: [[0,0], [1,1]]}}
    p "overlap_ranges #{overlap_ranges}, expected: #{expected_overlap} #{overlap_ranges == expected_overlap}"
    p "updated_list #{updated_list}, expected: #{[[0,0],[1,1],[5,9]]} #{updated_list == [[0,0],[1,1],[5,9]]}"
    p "-----"

    list = [[5,9], [11,12]]
    new_range = [2,16]
    overlap_ranges, updated_list = get_overlap_ranges(list, new_range)
    p "new range: #{new_range}"
    p "list: #{list}"
    expected_overlap = {[5,9] => {overlap: [5, 9], all_ranges: [[5,9]]}, [11,12] => {overlap: [11, 12], all_ranges: [[11,12]]}}
    p "overlap_ranges #{overlap_ranges}, expected: #{expected_overlap} #{overlap_ranges == expected_overlap}"
    p "updated_list #{updated_list}, expected: #{[[5,9], [11,12]]} #{updated_list == [[5,9], [11,12]]}"
    p "-----"

    list = [[9, 9], [10, 10], [11, 11]]
    new_range =  [11, 13]
    overlap_ranges, updated_list = get_overlap_ranges(list, new_range)
    p "new range: #{new_range}"
    p "list: #{list}"
    expected_overlap = {[11, 11] => {overlap: [11, 11], all_ranges: [[11,11]]}}
    p "overlap_ranges #{overlap_ranges}, expected: #{expected_overlap} #{overlap_ranges == expected_overlap}"
    p "updated_list #{updated_list}, expected: #{[[9, 9], [10, 10], [11, 11]]} #{updated_list == [[9, 9], [10, 10], [11, 11]]}"
    p "-----"

    list = [[9, 9], [10, 10], [11, 11], [12, 13]]
    new_range =  [10, 12]
    overlap_ranges, updated_list = get_overlap_ranges(list, new_range)
    p "new range: #{new_range}"
    p "list: #{list}"
    expected_overlap = {[10, 10] => {overlap: [10, 10], all_ranges: [[10, 10]]}, [11, 11] => {overlap: [11, 11], all_ranges: [[11, 11]]}, [12, 13] => {overlap: [12, 12], all_ranges: [[12, 12], [13, 13]]}}
    p "overlap_ranges #{overlap_ranges}, expected: #{expected_overlap} #{overlap_ranges == expected_overlap}"
    p "updated_list #{updated_list}, expected: #{[[9, 9], [10, 10], [11, 11], [12, 12], [13, 13]]} #{updated_list == [[9, 9], [10, 10], [11, 11], [12, 12], [13, 13]]}"
    p "-----"

    list = [[26, 34], [35, 39], [40, 47]]
    new_range =  [-5, 47]
    overlap_ranges, updated_list = get_overlap_ranges(list, new_range)
    p "new range: #{new_range}"
    p "list: #{list}"
    expected_overlap = {[26, 34] => {overlap: [26, 34], all_ranges: [[26, 34]]}, [35, 39] => {overlap: [35, 39], all_ranges: [[35, 39]]}, [40, 47] => {overlap: [40, 47], all_ranges: [[40, 47]]}}
    p "overlap_ranges #{overlap_ranges}, expected: #{expected_overlap} #{overlap_ranges == expected_overlap}"
    p "updated_list #{updated_list}, expected: #{[[26, 34], [35, 39], [40, 47]]} #{updated_list == [[26, 34], [35, 39], [40, 47]]}"
    p "-----"
end

def tests
    test_no_overlap()
    test_overlap()
end

# test_no_overlap()
# test_overlap()
# tests()