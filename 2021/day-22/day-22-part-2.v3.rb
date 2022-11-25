require_relative '../helper'
include Helper

reboot_data = Helper::upload("day-22/input.txt")
reboot_data_test_1 = Helper::upload("day-22/test-input-1.txt")
reboot_data_test_2 = Helper::upload("day-22/test-input-2.txt")
reboot_data_test_3 = Helper::upload("day-22/test-input-3.txt")

COORDS = ["x", "y", "z"]

def perform_reboot_steps reboot_data
    steps = reboot_data.map {|step| step.split(" ")}.map {|step| [step[0], step[1].split(",").map {|range| range[/[^=]*$/].split("..").join("-")}] }

    cuboid_tree = [create_node(steps[0][1], "x")]
    p cuboid_tree
    new_cuboid_tree = []

    steps.drop(1).each do |step|
        switch = step[0]
        x_range, y_range, z_range = step[1]
        x_added, y_added, z_added = false

        cuboid_tree.each_with_index do |tree_x, tree_x_index|
            p tree_x
            no_overlap = check_for_no_overlap(x_range, tree_x[:range])
            if no_overlap
                if !x_added && is_before(x_range, tree_x[:range])
                    new_cuboid_tree.push(create_node(step[1], "x"))
                    x_added = true
                else
                    new_cuboid_tree.push[tree_x]
                end
                p "new cuboid tree:"
                p new_cuboid_tree
            else
                x_added = true
                switch_range = find_switch_range(x_range, tree_x[:range])
                before_range = find_before_range(x_range, tree_x[:range])
                # after_range = find_after_range(x_range, tree_x[:range])
                new_cuboid_tree.push({:range => before_range, :children => tree_x[:children] }) unless before_range.nil?
                x_children = find_x_children(y_range, tree_x[:children], step[1])
                new_cuboid_tree.push({:range => switch_range, :children => x_children})
                # new_cuboid_tree.push({:range => after_range, :children => tree_x[:children] }) unless after_range.nil?
            end

        end

        # p step
        #

    end
end

def create_node(ranges, level)
    z = [{:range => ranges[2]}]
    return z if level === "z"
    y = [ {:range => ranges[1], :children => z}]
    return y if level === "y"
    x = {:range => ranges[0], :children => y}
    return x
end

def check_for_no_overlap(range_1, range_2)
    x_range_1 = range_1[/([^-]+)/].to_i
    y_range_1 = range_1[/[^-]*$/].to_i

    x_range_2 = range_2[/([^-]+)/].to_i
    y_range_2 = range_2[/[^-]*$/].to_i

    x_range_1 > y_range_2 && x_range_2 < y_range_1
end

def is_before(range_1, range_2)
    x_range_2 = range_2[/([^-]+)/].to_i
    y_range_1 = range_1[/[^-]*$/].to_i
    x_range_2 < y_range_1
end

def find_switch_range(range_1, range_2)
    x_range_1 = range_1[/([^-]+)/].to_i
    y_range_1 = range_1[/[^-]*$/].to_i

    x_range_2 = range_2[/([^-]+)/].to_i
    y_range_2 = range_2[/[^-]*$/].to_i

    x = [x_range_1, x_range_2].max
    y = [y_range_1, y_range_2].min

    "#{x},#{y}"
end

def find_before_range(range_1, range_2)
    x_range_1 = range_1[/([^-]+)/].to_i
    y_range_1 = range_1[/[^-]*$/].to_i

    x_range_2 = range_2[/([^-]+)/].to_i
    y_range_2 = range_2[/[^-]*$/].to_i

    x_range_2 < x_range_1 ? "#{x_range_2}-#{x_range_1 - 1}" : nil
end

def find_x_children(y_range, tree, step)
    new_children_tree = []
    y_added = false
    tree.each_with_index do |tree_y, tree_y_index|
        p tree_y
        no_overlap = check_for_no_overlap(y_range, tree_y[:range])
        if no_overlap
            if !y_added && is_before(y_range, tree_y[:range])
                new_children_tree.push(create_node(step, "y"))
                y_added = true
            else
                new_children_tree.push[tree_y]
            end
        else
            y_added = true
            switch_range = find_switch_range(y_range, tree_y[:range])
            before_range = find_before_range(y_range, tree_y[:range])
            # after_range = find_after_range(x_range, tree_x[:range])
            new_children_tree.push({:range => before_range, :children => tree_y[:children] }) unless before_range.nil?
            y_children = find_y_children(step[2], tree_y[:children], step)
            new_children_tree.push({:range => switch_range, :children => y_children})
            # new_children_tree.push({:range => after_range, :children => tree_x[:children] }) unless after_range.nil?
        end
    end
    new_children_tree
end

def find_y_children(z_range, tree_z, step)
    p tree_z
    new_children_tree = []
    z_added = false
    no_overlap = check_for_no_overlap(z_range, tree_z[:range])
    if no_overlap
        if !z_added && is_before(z_range, tree_z[:range])
            new_children_tree.push(create_node(step, "z"))
            z_added = true
        else
            new_children_tree.push[tree_z]
        end
    else
        z_added = true
        switch_range = find_switch_range(z_range, tree_z[:range])
        before_range = find_before_range(z_range, tree_z[:range])
        # after_range = find_after_range(x_range, tree_x[:range])
        new_children_tree.push({:range => before_range }) unless before_range.nil?
        new_children_tree.push({:range => switch_range})
        # new_children_tree.push({:range => after_range}) unless after_range.nil?
    end
    new_children_tree
end

perform_reboot_steps reboot_data_test_1