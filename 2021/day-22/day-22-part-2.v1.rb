require_relative '../helper'
include Helper

reboot_data = Helper::upload("2021/day-22/input.txt")
reboot_data_test_1 = Helper::upload("2021/day-22/test-input-1.txt")
reboot_data_test_2 = Helper::upload("2021/day-22/test-input-2.txt")
reboot_data_test_3 = Helper::upload("2021/day-22/test-input-3.txt")

COORDS = ["x", "y", "z"]

def perform_reboot_steps reboot_data
    steps = reboot_data.map {|step| step.split(" ")}.map {|step| [step[0], step[1].split(",").map {|range| range[/[^=]*$/].split("..").map(&:to_i)}] }
    # p steps
    step_ranges = []

    cuboids = Hash.new(false)

    steps.each_with_index do |step, index|
        p "doing step #{index} of #{steps.length - 1}"

        is_on = step[0] === "on"
        # p "turn #{is_on ? "on" : "off"}"
        
        x_min = step[1][0][0].to_i
        x_max = step[1][0][1].to_i
        y_min = step[1][1][0].to_i
        y_max = step[1][1][1].to_i
        z_min = step[1][2][0].to_i
        z_max = step[1][2][1].to_i

        if step_ranges.length === 0
            step_ranges.push([[x_min,x_max]])
            step_ranges.push([[y_min,y_max]])
            step_ranges.push([[z_min,z_max]])
            # p step_ranges
            next
        end

        # p step_ranges
        new_step_ranges = []
        
        step_ranges.each_with_index do |coord_ranges, coord_index|
            # p "new #{COORDS[coord_index]} range: #{step[1][coord_index].join("-")}"
            # p coord_ranges
            coord_min = step[1][coord_index][0]
            coord_max = step[1][coord_index][1]
            new_coord_ranges = []
            carry_over_x_value = nil
            carrying_over_y = false
            coord_ranges.each_with_index do |range, range_index|
                # p "check new range with: #{range}"
                last_index = coord_ranges.length - 1
                
                # p "condition 1: #{carrying_over_y}"
                if carrying_over_y
                    if coord_max < range[0]
                        new_coord_ranges.push([carry_over_x_value, coord_max])
                        new_coord_ranges.push(range)
                        # TODO: make sure the next range gets added
                        carrying_over_y = false
                    elsif coord_max > range[0] && coord_max < range[1]
                        new_coord_ranges.push([carry_over_x_value, range[1]])
                        carrying_over_y = false
                    end

                    next
                end

                # p "condition 2: #{range[0] > coord_max || range[1] < coord_min}"
                if range[0] > coord_max || range[1] < coord_min
                    if last_index
                        new_coord_ranges.push([coord_min, coord_max],range) if range[0] > coord_max
                        new_coord_ranges.push(range, [coord_min, coord_max]) if range[1] < coord_min
                    end
                    new_coord_ranges.push(range)
                    next
                end

                # p "condition 3: #{range[0]} < #{coord_min} && #{range[0]} < #{coord_max} : #{range[0] < coord_min && range[0] < coord_max}"
                if is_on && range[0] < coord_min && range[0] < coord_max
                    if last_index
                        new_coord_ranges.push([range[0], coord_max])
                    else
                        carry_over_x_value = range[0]
                        carrying_over_y = true
                    end
                    next
                end

                if !is_on && range[0] < coord_max && range[1] >= (coord_max + 1)
                    if last_index
                        # p "AM HERE"
                        # p new_coord_ranges
                        # p [coord_max, range[1]]
                        new_coord_ranges.push([coord_max + 1, range[1]])
                        # p new_coord_ranges
                    else
                        carry_over_x_value = coord_max + 1
                        carrying_over_y = true
                    end
                    next
                end

            end
            # p "new_coord_ranges: #{new_coord_ranges}"
            new_step_ranges.push(new_coord_ranges)
            # p new_step_ranges

        end

        p "new_step_ranges: #{new_step_ranges}"
        step_ranges = Helper::deep_copy(new_step_ranges)
        # (x_min..x_max).each do |x|
        #     (y_min..y_max).each do |y|
        #         (z_min..z_max).each do |z|
        #             cuboids["#{x},#{y},#{z}"] = is_on
        #         end
        #     end
        # end
    end
    p step_ranges

    total_on = step_ranges.map {|coord| coord.map {|range| range[1] - range[0] + 1} }
    p total_on
    # p cuboids.select {|key, value| value}
    # p cuboids.count(&:last)
    # p "x=10..12"[/[^=]/] # gives x
    # p "x=10..12"[/[^=]*$/] # gives x

end

perform_reboot_steps reboot_data_test_1