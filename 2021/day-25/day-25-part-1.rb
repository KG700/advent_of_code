require_relative '../helper'
include Helper

cucumber_data = Helper::upload("day-25/input.txt")
cucumber_data_test = Helper::upload("day-25/test-input.txt")
cucumber_data_test_basic = Helper::upload("day-25/test-input-basic.txt")

class SeaFloor

    MOVES = [">", "v"]

    attr_accessor :floor, :step, :moved

    def initialize floor_data
        rowEdge = floor_data.length
        colEdge = floor_data[0].length
        @floor = floor_data.each_with_index.map do |row, rowIndex | 
            row.split('').each_with_index.map do |type, colIndex| 
                (type != ".") ? SeaCucumber.new(type, {row: rowIndex, col: colIndex}, {row: rowEdge, col: colEdge}) : "." 
            end
        end
        @move_type = ">"
        @step = 1
        @cucumbers_can_move = {">": false, "v": false}
        @moved = false
    end

    def next_step
        @moved = false
        MOVES.each do |move|
            @move_type = move
            move_stage_1
            if @cucumbers_can_move[:@move_type]
                @moved = true
                moving_stage_2
            end
            @cucumbers_can_move[:@move_type] = false
        end
        @step += 1 if @moved
    end

    def cucumber_can_move? cucumber
        row = cucumber.next_position[:row]
        col = cucumber.next_position[:col]
        @floor[row][col] == "."
    end

    def print_floor_map
        floor_map = []
        @floor.each do |row|
            row_map = ""
            row.each do |col| 
                col == "." ? row_map += col : row_map += col.type
            end
            floor_map.push(row_map) 
        end
        floor_map.each { |row| p row }
    end 

    private
    def move_stage_1
        @floor.each do |row| 
            row.each do |cucumber| 
                if cucumber != "."
                    cucumber.update_next_position
                    if (@move_type == cucumber.type && cucumber_can_move?(cucumber))
                        cucumber.moving = true
                        @cucumbers_can_move[:@move_type] = true
                    end
                end
            end
        end
    end

    def moving_stage_2
        @floor.each_with_index do |floor_row, rowIndex| 
            floor_row.each_with_index do |cucumber, colIndex| 
                if cucumber != "." && cucumber.moving
                    
                    row = cucumber.position[:row]
                    col = cucumber.position[:col]
                    @floor[row][col] = "."

                    row = cucumber.next_position[:row]
                    col = cucumber.next_position[:col]
                    @floor[row][col] = cucumber

                    cucumber.position = Helper::deep_copy(cucumber.next_position)
                    cucumber.moving = false
                end
            end
        end
    end

end

class SeaCucumber
    attr_accessor :type, :position, :next_position, :moving
    attr_reader :edge

    def initialize type, position, edge
        @type = type
        @position = position
        @edge = edge
        @next_position = {}
        @moving = false
    end

    def update_next_position
        @next_position[:row] = @type == "v" ? (@position[:row] + 1) % @edge[:row] : @position[:row]
        @next_position[:col] = @type == ">" ? (@position[:col] + 1) % @edge[:col] : @position[:col]
    end
end

def simulate_cucumbers cucumbers

    sea_floor = SeaFloor.new(cucumbers)

    loop do
        sea_floor.next_step
        break unless sea_floor.moved
    end

    p sea_floor.step

end

simulate_cucumbers cucumber_data