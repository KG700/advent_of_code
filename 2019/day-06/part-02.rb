require_relative '../helper'
include Helper

orbit_data = Helper::upload("2019/day-06/input.txt")
orbit_data_test_2 = Helper::upload("2019/day-06/input-test-2.txt")

def count_orbits orbit_data

    space_objects = {}
    orbit_data.each do |orbit| 
        orbitee, orbitor = orbit.split(")")
        throw "Error" if space_objects.key?(orbitor)
        space_objects[orbitor] = orbitee
    end

    you_orbits = get_orbits('YOU', space_objects)
    san_orbits = get_orbits('SAN', space_objects)
    orbital_transfers = nil

    (you_orbits.length + san_orbits.length).times do |transfers|

        transfers.times do |index|
            if you_orbits[index] == san_orbits[transfers - index]
                orbital_transfers = transfers
                break
            end
        end

        break unless orbital_transfers.nil?
    end

    p orbital_transfers

end

def get_orbits obj, space_objects
    orbits = []

    next_orbit = space_objects[obj]
    loop do
        break if next_orbit == "COM"
        break unless space_objects.key?(next_orbit)

        orbits.push(next_orbit)
        next_orbit = space_objects[next_orbit]
    end
    orbits
end

count_orbits orbit_data