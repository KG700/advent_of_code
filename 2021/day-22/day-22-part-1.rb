require_relative '../helper'
include Helper

reboot_data = Helper::upload("day-22/input.txt")
reboot_data_test_1 = Helper::upload("day-22/test-input-1.txt")
reboot_data_test_2 = Helper::upload("day-22/test-input-2.txt")

reboot_data_test_4 = Helper::upload("day-22/test-input-4.txt")


COORDS = ["x", "y", "z"]
MIN = -50
MAX = 50

def perform_reboot_steps reboot_data
    steps = reboot_data.map {|step| step.split(" ")}.map {|step| [step[0], step[1].split(",").map {|range| range[/[^=]*$/].split("..")}] }

    cuboids = Hash.new(false)

    steps.each do |step|

        is_on = step[0] === "on"
        
        x_min = [step[1][0][0].to_i, MIN].max
        x_max = [step[1][0][1].to_i, MAX].min
        y_min = [step[1][1][0].to_i, MIN].max
        y_max = [step[1][1][1].to_i, MAX].min
        z_min = [step[1][2][0].to_i, MIN].max
        z_max = [step[1][2][1].to_i, MAX].min

        step_in_range = x_min <= x_max || y_min <= y_max || z_min <= z_max
        next if !step_in_range

        (x_min..x_max).each do |x|
            (y_min..y_max).each do |y|
                (z_min..z_max).each do |z|
                    cuboids["#{x},#{y},#{z}"] = is_on
                end
            end
        end
    end

    # cuboids.each {|key, value| p key if value}
    p cuboids.count(&:last)

end

perform_reboot_steps reboot_data_test_4