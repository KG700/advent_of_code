require 'set'
require_relative '../helper'
include Helper

reboot_data = Helper::upload("2021/day-22/input.txt")
reboot_data_test_1 = Helper::upload("2021/day-22/test-input-1.txt")
reboot_data_test_2 = Helper::upload("2021/day-22/test-input-2.txt")
reboot_data_test_3 = Helper::upload("2021/day-22/test-input-3.txt")

COORDS = ["x", "y", "z"]

def perform_reboot_steps reboot_data
    steps = reboot_data.map {|step| step.split(" ")}.map {|step| [step[0], step[1].split(",").map {|range| range[/[^=]*$/].split("..")}] }
    steps.map! do |step|
        [step[0], Set.new(step[1][0][0]..step[1][0][1]), Set.new(step[1][2][0]..step[1][1][1]), Set.new(step[1][2][0]..step[1][2][1])]
    end
    # p steps
    # cuboids = Hash.new {|h,k| h[k] = Set[]}
    cuboids = 0

    # 1. find overall x_min, x_max etc across all step
    # 2. do loop through x, y and z ranges
    # 3. work backwards through the steps to find a step
        # contains the x, y, z combination. Break when found.
        # if it stops on an 'on' step, add to the count

        # p "doing step #{index + 1} of #{steps.length}"
        
        # is_on = step[0] === "on"
        # p "is on: #{is_on}"

        x_set = Set.new
        y_set = Set.new
        z_set = Set.new

        steps.each do |step|
            x_set = x_set | step[1]
            y_set = y_set | step[2]
            z_set = z_set | step[3]
        end

        p "total x: #{x_set.size}"
        p "total y: #{y_set.size}"
        p "total z: #{z_set.size}"
        # p "total loops will be: #{(x_max - x_min + 1) * (y_max - y_min + 1) * (z_max - z_min + 1)}"

        start = Time.now

        x_set.each_with_index do |x, index|
            p "x loop: #{index}, time taken: #{Time.now - start} secs" if index % 1 == 0
            y_set.each do |y|
                z_set.each do |z|
    
                    steps.reverse.each do |step|
                        in_x_range = step[1] === x
                        next unless in_x_range
                        in_y_range = step[2] === y
                        next unless in_y_range
                        in_z_range = step[3] === z
                        next unless in_z_range
                        # if in_x_range && in_y_range && in_z_range
                        cuboids += 1 if step[0] == 'on'
                        break
                        # end
                    end
                    # in_cuboid = cuboids.scan(/#{cube}/).length > 0
                    # cuboids += cube if !in_cuboid && is_on
                    # if in_cuboid && !is_on
                    #     cuboids.slice! cube
                    #     # cuboids.gsub!(/#{cube}/, "")
                    # end
                end
            end
        # p cuboids
        # p "number of cuboids: #{cuboids}"
    end

    # count = 0
    # p cuboids
    # cuboids.each {|key, value| count += value.count}
    # p count
    # p cuboids.count(&:last)
    p cuboids

end

perform_reboot_steps reboot_data_test_3