require_relative '../helper'
include Helper

test_1_numbers = ["939","7,13,x,x,59,x,31,19"] # 1068781
test_2_numbers = ["939","17,x,13,19"] # 3417
test_3_numbers = ["939","67,7,59,61"] # 754018
test_4_numbers = ["939","67,x,7,59,61"] # 779210
test_5_numbers = ["939","67,7,x,59,61"] # 1261476
test_6_numbers = ["939","1789,37,47,1889"] # 1202161486

bus_numbers = Helper::upload("day-13/bus-data.txt")

def find_timestamp_brute_force buses
    bus_numbers = []
    max_bus_number = buses[1].split(",").map(&:to_i).each_with_index.max
    buses[1].split(",").map(&:to_i).each_with_index { |bus, index| bus_numbers.push({ "index" => index, "num" => bus }) }
    bus_numbers.select! { |bus| bus["num"] != 0 }

    iterator = max_bus_number[0]
    timestamp = max_bus_number[0] - max_bus_number[1]
    loop do
        meets_criteria = true
        bus_numbers.each do |bus|
            if (timestamp + bus["index"]) % bus["num"] != 0
                meets_criteria = false
            end
        end
        break if meets_criteria
        timestamp += iterator
    end
    p timestamp
end

def find_timestamp timetable
    buses = []
    timetable[1].split(",").map(&:to_i).each_with_index { |bus, index| buses.push({ "index" => index, "num" => bus }) }
    buses.select! { |bus| bus["num"] != 0 }

    # Use Chinese Remainder Theorem:
    # T = index (mod bus_num)
    buses.each_with_index do |bus|
        bus["mult"] = 1
        buses.each_with_index do |other_bus|
            if bus["num"] != other_bus["num"]
                bus["mult"] *= other_bus["num"]
            end
        end
    end
    p buses

    # Use modular inverse to find number to multiply by to give remainder of index
    buses.each do |bus|
        num = bus["mult"] % bus["num"]
        bus["mult"] *= inv_mod(num, bus["num"], bus["index"])
        p bus["mult"] % bus["num"]
        p bus["index"]
    end

    mult_added_up = 0
    buses_multiplied = 1
    buses.each do |bus|
        mult_added_up += bus["mult"]
        buses_multiplied *= bus["num"]
    end

    # buses.each { |bus| p "#{bus["index"]} and #{mult_added_up % bus["num"]}" }
    p buses
    p mult_added_up
    p buses_multiplied
    p 3 * buses_multiplied - mult_added_up 
    answer = 8 * buses_multiplied - mult_added_up
    buses.each { |bus| p "#{bus["index"]} and #{answer % bus["num"]}" }


end

# 1068781

def find_mult(num, mod, remainder)
    res = nil
    (0..num).each do |step|
        if (step * num) % mod == remainder
            return step
        end
    end
    res
end

def inv_mod(num, mod, index)
  res = nil
  (0..mod).each do |step|
    k = (step * mod) + index
    return k / num if (k % num == 0 && k != 0)
   end
  res
end

find_timestamp test_1_numbers
# p find_mult(15, 4, 2)
# p inv_mod(146, 60)