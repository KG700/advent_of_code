require_relative '../helper'
include Helper

mass_data = Helper::upload("2019/day-01/input.txt")

def calculate_fuel modules
    modules.map!(&:to_i)
    p modules.reduce(0) { |fuel, mass| fuel + (mass/3) - 2 }
end

calculate_fuel mass_data