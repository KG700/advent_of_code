
TEST_VALUES_1 = [20, 30, -10, -5]
REAL_VALUES = [85, 145, -163, -108]


def probe_trajectory target

    target_x_min, target_x_max, target_y_min, target_y_max = target
    overall_max_height = 0

    (target_x_min).times do |x_velocity|

        163.times do |y_velocity|
            current_position = [0,0]
            velocity = [x_velocity, y_velocity]

            x_dropping = false
            in_target = false
            max_height = 0
        
            n = 1
            loop do
                x,y = current_position

                break if x > target_x_max
                break if y < target_y_min
                
                constant = ((n-1)**2 + (n-1))/2

                if (n * velocity[0])/2 === constant
                    x_dropping = true
                end
     
                next_x = x_dropping ? x : n * velocity[0] - constant
                next_y = n * velocity[1] - constant
                max_height = next_y if next_y > max_height

                in_target = true if next_x >= target_x_min && next_x <= target_x_max && next_y >= target_y_min && next_y <= target_y_max
                
                
                n += 1
                
                # p [next_x, next_y]
                current_position = [next_x, next_y]
                
                break if in_target
            end

            p max_height if in_target && max_height > overall_max_height
            overall_max_height = max_height if in_target && max_height > overall_max_height
        end


    end
    
    p overall_max_height

    # p current_position
    # p in_target
    # p max_height

end

probe_trajectory REAL_VALUES