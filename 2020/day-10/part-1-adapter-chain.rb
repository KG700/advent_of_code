require_relative '../helper'
include Helper

def adapter_chain adapters
    adapters.sort!

    jolts = { 1 => 0, 2=>0, 3 => 1}
    jolts[adapters[0]] += 1
    
    adapters.each_cons(2) { |j1, j2| jolts[(j2-j1)] += 1 }
    p jolts[1] * jolts[3]
    
end

jolt_data = Helper::upload("day-10/jolt-data.txt").map(&:to_i)
test_1_data = [16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4]
test_2_data = [28, 33, 18, 42, 31, 14, 46, 20, 48, 47, 24, 23, 49, 45, 19, 38, 39, 11, 1, 32, 25, 35, 8, 17, 7, 9, 4,2, 34, 10, 3]

adapter_chain jolt_data
