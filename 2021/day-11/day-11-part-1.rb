require_relative '../helper'
include Helper

octapus_data = Helper::upload("2021/day-11/part-1-input.txt")
octapus_test_data = Helper::upload("2021/day-11/test-input.txt")

def simulate_lumination octapus_data

    flash_count = 0
    octapus_hash = Hash.new
    
    10.times { |row| 10.times {|col| octapus_hash["#{row},#{col}"] = {:energy => octapus_data[row][col].to_i, :adjacents => find_adjacents(row,col), :flashed => false}} }
    
    100.times do |step|
        octapus_hash.each { |coords, octapus| octapus[:energy] += 1 }

        loop do
            flashed = []
            octapus_hash.each do |coords, octapus|
                if !octapus[:flashed] && octapus[:energy] > 9
                    octapus[:flashed] = true
                    flashed.push(coords)
                end
            end
            break if flashed.length == 0
            flash_count += flashed.length

            flashed.each {|coords| octapus_hash[coords][:adjacents].each {|adj_coords| octapus_hash[adj_coords][:energy] += 1 }}
        end

        octapus_hash.each do |coords, octapus|
            if octapus[:flashed]
                octapus[:energy] = 0
                octapus[:flashed] = false
            end
        end
    end
    p flash_count
end

def find_adjacents(row,col)
    adjacents = []
    adjacents.push("#{row - 1},#{col}") if row - 1 >= 0
    adjacents.push("#{row - 1},#{col + 1}") if row - 1 >= 0 && col + 1 <= 9
    adjacents.push("#{row},#{col + 1}") if col + 1 <= 9
    adjacents.push("#{row + 1},#{col + 1}") if row + 1 <= 9 && col + 1 <= 9
    adjacents.push("#{row + 1},#{col}") if row + 1 <= 9
    adjacents.push("#{row + 1},#{col - 1}") if row + 1 <= 9 && col - 1 >= 0
    adjacents.push("#{row},#{col - 1}") if col - 1 >= 0
    adjacents.push("#{row - 1},#{col - 1}") if row - 1 >= 0 && col - 1 >= 0
    adjacents
end

simulate_lumination octapus_data