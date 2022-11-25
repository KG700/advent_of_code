require_relative '../helper'
include Helper

class Seat

    attr_reader :binary_id, :column_number, :row_number

    def initialize binary_id
        @binary_id = binary_id
        @row_number = set_row_number
        @column_number = set_column_number
    end

    def set_row_number
        row_binary_id = @binary_id.slice(0...7)
        @row_number = find_seat_number 0, 127, row_binary_id
    end

    def set_column_number
        column_binary_id = @binary_id.slice(7...11)
        @column_number = find_seat_number 0, 7, column_binary_id
    end

    def get_seat_id
        return row_number * 8 + column_number
    end

    private
    def find_seat_number lowest, highest, binary_id
        if binary_id.length == 1
            if (binary_id == "B" || binary_id == "R")
                return highest
            else 
                return lowest
            end
        end

        half_way = (lowest + highest) / 2
        if binary_id[0] == "B" || binary_id[0] == "R"
            lowest = half_way + 1
        else
            highest = half_way
        end
        find_seat_number lowest, highest, binary_id.slice!(1...binary_id.length)
    end

end

def highest_seat_id
    seats = upload("2020/day-05/seat-data.txt")

    seats.map! { |seat| Seat.new(seat) }
    max_id = 0
    seats.each do |seat|
        if seat.get_seat_id > max_id
            max_id = seat.get_seat_id
        end
    end
    p max_id
end

def find_my_seat
    seats = Helper::upload("2020/day-05/seat-data.txt")
    all_seat_ids = (1..1023).to_a
    seats.map! { |seat| Seat.new(seat) }

    seats.each { |seat| all_seat_ids.delete(seat.get_seat_id) }
    max_index = all_seat_ids.length
    my_seat = all_seat_ids.select.with_index do |seat, index|
        if seat > 0 && seat < 1023
            seat - all_seat_ids[index - 1] > 1 &&
            all_seat_ids[index + 1] - seat > 1
        end
    end
    p my_seat[0]
end

find_my_seat
