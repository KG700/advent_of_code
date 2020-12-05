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
    seats = upload("day-5/seat-data.txt")

    seats.map! { |seat| Seat.new(seat) }
    max_id = 0
    seats.each do |seat|
        if seat.get_seat_id > max_id
            max_id = seat.get_seat_id
        end
    end
    p max_id
end

def upload file
    file = File.open(file)
    file_data = file.readlines.map(&:chomp)
    file.close
    file_data
end

highest_seat_id
