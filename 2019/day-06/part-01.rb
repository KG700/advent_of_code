require_relative '../helper'
include Helper

orbit_data = Helper::upload("2019/day-06/input.txt")
orbit_data_test_1 = Helper::upload("2019/day-06/input-test-1.txt")

def count_orbits orbit_data

    space_objects = {}
    orbit_data.each do |orbit| 
        orbitee, orbitor = orbit.split(")")
        throw "Error" if space_objects.key?(orbitor)
        space_objects[orbitor] = orbitee
    end
    # p space_objects

    orbit_count = 0

    space_objects.each do |orbitor, orbitee|
        orbit_count += 1

        next_orbitor = orbitee
        loop do
            break if next_orbitor == "COM"
            break unless space_objects.key?(next_orbitor)
            orbit_count += 1 
            next_orbitor = space_objects[next_orbitor]
        end

    end
    p orbit_count

end

count_orbits orbit_data