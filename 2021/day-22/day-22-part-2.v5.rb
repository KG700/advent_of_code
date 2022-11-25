require 'set'
require_relative '../helper'
include Helper

reboot_data = Helper::upload("day-22/input.txt")
reboot_data_test_1 = Helper::upload("day-22/test-input-1.txt")
reboot_data_test_2 = Helper::upload("day-22/test-input-2.txt")
reboot_data_test_3 = Helper::upload("day-22/test-input-3.txt")

COORDS = ["x", "y", "z"]

def perform_reboot_steps reboot_data
    steps = reboot_data.map {|step| step.split(" ")}.map {|step| [step[0], step[1].split(",").map {|range| range[/[^=]*$/].split("..")}] }

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

        x_min = Float::INFINITY
        x_max = 0
        y_min = Float::INFINITY
        y_max = 0
        z_min = Float::INFINITY
        z_max = 0

        steps.each do |step|
            x_min = [step[1][0][0].to_i, x_min].min
            x_max = [step[1][0][1].to_i, x_max].max
            y_min = [step[1][1][0].to_i, y_min].min
            y_max = [step[1][1][1].to_i, y_max].max
            z_min = [step[1][2][0].to_i, z_min].min
            z_max = [step[1][2][1].to_i, z_max].max
        end

        p "total x: #{x_max - x_min + 1}"
        p "total y: #{y_max - y_min + 1}"
        p "total z: #{z_max - z_min + 1}"
        p "min x: #{x_min}, max x: #{x_max}"
        # p "total loops will be: #{(x_max - x_min + 1) * (y_max - y_min + 1) * (z_max - z_min + 1)}"

        start = Time.now

        (x_min..x_max).each do |x|
            p "x loop: #{x}, time taken: #{Time.now - start} secs" if x % 10 == 0
            
            in_x_range = false
            steps.each do |step_x|
                in_x_range = x >= step_x[1][0][0].to_i && x <= step_x[1][0][1].to_i
                break if in_x_range
            end

            next unless in_x_range

            (y_min..y_max).each do |y|

                in_y_range = false
                steps.each do |step_y|
                    in_y_range = y >= step_y[1][1][0].to_i && y <= step_y[1][1][1].to_i
                    break if in_y_range
                end

                next unless in_y_range

                (z_min..z_max).each do |z|
    
                    steps.reverse.each do |step|
                        in_x_range = x >= step[1][0][0].to_i && x <= step[1][0][1].to_i
                        next unless in_x_range
                        in_y_range = y >= step[1][1][0].to_i && y <= step[1][1][1].to_i
                        next unless in_y_range
                        in_z_range = z >= step[1][2][0].to_i && z <= step[1][2][1].to_i
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