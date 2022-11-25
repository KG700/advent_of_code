require 'set'
require_relative '../helper'
include Helper

beacon_data = Helper::upload("day-19/input.txt")
beacon_data_test_1 = Helper::upload("day-19/test-input-1.txt")
beacon_data_test_2 = Helper::upload("day-19/test-input-2.txt")

class Map
    attr_accessor :beacons

    def initialize beacons
        @beacons = beacons
    end

    def add beacons
        @beacons.merge(beacons)
    end

end

class Scanner

    MINIMUM_OVERLAP = 12

    attr_accessor :beacons, :coords, :orientation

    def initialize
        @beacons = Set.new
        @coords = nil
        @orientation = nil
    end

    def add beacon
        @beacons.add(beacon)
    end

    def locate map_beacons
        (0..23).each do |index|
            overlap_count = Hash.new(0)
            scanner_becons = rotate(index)
            scanner_becons.each do |scanner_beacon|
                map_beacons.each do |map_beacon|
                    x_diff = map_beacon[0] - scanner_beacon[0]
                    y_diff = map_beacon[1] - scanner_beacon[1]
                    z_diff = map_beacon[2] - scanner_beacon[2]
                    overlap_count[[x_diff, y_diff, z_diff]] += 1
                end
            end
            max_overlap = {coords: nil, count: 0}
            overlap_count.each do |coords, count| 
                if count > max_overlap[:count]
                    max_overlap[:coords] = coords
                    max_overlap[:count] = count
                end
            end
            if max_overlap[:count] >= MINIMUM_OVERLAP
                @coords = max_overlap[:coords]
                @orientation = index
                break
            end
        end

    end

    def beacons_relative_to_map
        rotated_beacons = rotate(@orientation)
        relative_beacons = rotated_beacons.map do |beacon|
            beacon[0] += @coords[0]
            beacon[1] += @coords[1]
            beacon[2] += @coords[2]
            beacon
        end
    end

    def rotate_beacon(coords, index)
        x, y, z = coords
        orientations = [
            [x, y, z],
            [x, y*(-1), z*(-1)],
            [x, z, y*(-1)],
            [x, z*(-1), y],
            [x*(-1), y, z*(-1)],
            [x*(-1), y*(-1), z],
            [x*(-1), z, y],
            [x*(-1), z*(-1), y*(-1)],
            [y, x, z*(-1)],
            [y, x*(-1), z],
            [y, z, x],
            [y, z*(-1), x*(-1)],
            [y*(-1), x, z],
            [y*(-1), x*(-1), z*(-1)],
            [y*(-1), z, x*(-1)],
            [y*(-1), z*(-1), x],
            [z, x, y],
            [z, x*(-1), y*(-1)],
            [z, y, x*(-1)],
            [z, y*(-1), x],
            [z*(-1), x, y*(-1)],
            [z*(-1), x*(-1), y],
            [z*(-1), y, x],
            [z*(-1), y*(-1), x*(-1)]
        ]
        return orientations[index]
    end

    def rotate index
        rotated_beacons = @beacons.map do |beacon|
            rotate_beacon(beacon, index)
        end
    end
end

def start data
    first_scanner, *scanners = get_scanners data
    first_scanner.coords = [0,0,0]
    map = Map.new(first_scanner.beacons)

    next_scanners = []
    num_scanners = scanners.length

    loop do
        next_scanners = []
        scanners.each do |scanner|
            next unless scanner.coords.nil?
            scanner.locate map.beacons
            if scanner.coords.nil?
                next_scanners.push(scanner)
            else
                map.add scanner.beacons_relative_to_map
            end
        end
        break if next_scanners.length == 0
        break if next_scanners.length == num_scanners
        # throw "Error: infinite loop detected" if next_scanners.length == num_scanners
        num_scanners = next_scanners.length
    end

    max_distance = 0
    scanners.push(first_scanner)
    scanners.each do |scanner_1|
        scanners.each do |scanner_2|
            x_distance = (scanner_1.coords[0] - scanner_2.coords[0]).abs
            y_distance = (scanner_1.coords[1] - scanner_2.coords[1]).abs
            z_distance = (scanner_1.coords[2] - scanner_2.coords[2]).abs
            distance = x_distance + y_distance + z_distance
            max_distance = [max_distance, distance].max
        end
    end

    p max_distance

end

def get_scanners scanner_data
    scanners = []
    new_scanner = nil
    scanner_data.each do |scanner|
        next if scanner.empty?
        if scanner.include? "scanner"
            scanners.push(new_scanner) unless new_scanner.nil?
            new_scanner = Scanner.new()
        else
            beacon_coords = scanner.split(",").map(&:to_i)
            new_scanner.add beacon_coords
        end
    end
    scanners.push(new_scanner)
end


start beacon_data