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

    # cuboids = Hash.new {|h,k| h[k] = Set[]}
    cuboids = ""

    steps.each_with_index do |step, index|
        p "doing step #{index + 1} of #{steps.length}"

        is_on = step[0] === "on"
        # p "is on: #{is_on}"
        
        x_min = step[1][0][0].to_i
        x_max = step[1][0][1].to_i
        y_min = step[1][1][0].to_i
        y_max = step[1][1][1].to_i
        z_min = step[1][2][0].to_i
        z_max = step[1][2][1].to_i

        (x_min..x_max).each do |x|
            (y_min..y_max).each do |y|
                (z_min..z_max).each do |z|
                    cube = "#{x},#{y},#{z};"
                    # in_cuboid = cuboids.include?(cube)
                    in_cuboid = cuboids.scan(/#{cube}/).length > 0
                    cuboids += cube if !in_cuboid && is_on
                    if in_cuboid && !is_on
                        cuboids.slice! cube
                        # cuboids.gsub!(/#{cube}/, "")
                    end
                end
            end
        end
        # p cuboids
        p "number of cuboids: #{cuboids.count ";"}"
    end

    # count = 0
    # p cuboids
    # cuboids.each {|key, value| count += value.count}
    # p count
    # p cuboids.count(&:last)
    p cuboids.count ";"

end

perform_reboot_steps reboot_data_test_1