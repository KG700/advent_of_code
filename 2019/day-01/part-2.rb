require_relative '../helper'
include Helper

mass_data = Helper::upload("2019/day-01/input.txt")

def calculate modules
    modules.map!(&:to_i)
    p modules.reduce(0) { |fuel, mass| fuel + calculate_fuel(mass) }
end

def calculate_fuel mass
    fuel = 0
    extra_fuel = [(mass/3) - 2, 0].max

    while extra_fuel > 0 do
        fuel += extra_fuel
        extra_fuel = [(extra_fuel/3) - 2, 0].max
    end

    fuel
end

calculate mass_data