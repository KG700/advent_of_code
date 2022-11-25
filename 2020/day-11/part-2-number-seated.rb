require_relative '../helper'
include Helper

def number_seated seat_map
    seat_map.map! { |row| row.split("")}

    next_map = []
    # - If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
    # - If a seat is occupied (#) and five or more seats adjacent to it are also occupied, the seat becomes empty.
    # - Otherwise, the seat's state does not change.
    loop do
        is_changed = false
        next_map = Array.new(seat_map.length) { |row| Array.new(seat_map[0].length) }
        seat_map.each_with_index do |row, r| 
            row.each_with_index do |seat, c|  
                if seat == "."
                    next_map[r][c] = seat
                else
                    adjacent_seats = visible_seats(r,c, seat_map)
                    row_changed = has_row_changed seat, adjacent_seats
                    if row_changed
                        next_map[r][c] = '#' if seat == "L"
                        next_map[r][c] = 'L' if seat == "#"
                    else
                        next_map[r][c] = seat
                    end
                    is_changed = row_changed || is_changed
                end
            end 
        end
        seat_map = Marshal.load(Marshal.dump(next_map))
        break if !is_changed
    end
    count = 0
    seat_map.each { |row| row.each { |seat| count += 1 if seat == '#' }}
    p count
    
end

def has_row_changed seat, adjacent_seats
    is_changed = false
    is_changed = (seat == "L" && adjacent_seats.count('#') == 0) || is_changed
    is_changed = (seat == "#" && adjacent_seats.count('#') >= 5) || is_changed
end

def visible_seats r, c, map
    seats = []

    directions = ['R', 'D', 'L', 'U', 'RD', 'LD', 'LU', 'RU']

    directions.each do |direction|

        c_max = map[0].length - ((direction.include? 'R') ? 1 : 0)
        r_max = map.length - ((direction.include? 'D') ? 1 : 0)

        c_min = (direction.include? 'L') ? 0 : -1
        r_min = (direction.include? 'U') ? 0 : -1

        r_inc = get_r_inc direction
        c_inc = get_c_inc direction

        edge = get_edge direction, c_max, r_max, c, r

        if c > c_min && c < c_max && r > r_min && r < r_max
            (1..edge).each do |x|
                seat = map[r + r_inc * x][c + c_inc * x]
                if seat != '.'
                    seats.push(seat)
                    break
                end
            end
        end
    end

    return seats
end

def get_r_inc direction
    return inc = 1 if direction.include? 'D'
    return inc = -1 if direction.include? 'U'
    inc = 0
end

def get_c_inc direction
    return inc = 1 if direction.include? 'R'
    return inc = -1 if direction.include? 'L'
    inc = 0
end

def get_edge direction, c_max, r_max, c, r
    case direction
        when 'R'
            edge = c_max - c
        when 'D'
            edge = r_max - r
        when 'L'
            edge = c
        when 'U'
            edge = r
        when 'RD'
            edge = [c_max - c, r_max - r].min
        when 'LD'
            edge = [c, r_max - r].min
        when 'LU'
            edge = [c, r].min
        when 'RU'
            edge = [c_max - c, r].min
        end
    edge
end

seat_map = Helper::upload("2020/day-11/seating-data.txt")

test_map = [
    "L.LL.LL.LL",
    "LLLLLLL.LL",
    "L.L.L..L..",
    "LLLL.LL.LL",
    "L.LL.LL.LL",
    "L.LLLLL.LL",
    "..L.L.....",
    "LLLLLLLLLL",
    "L.LLLLLL.L",
    "L.LLLLL.LL"
]

test_2_map = [
    "L.LL",
    "LLLL",
    "L.L."
]

test_3_map = [
    ".......#.",
    "...#.....",
    ".#.......",
    ".........",
    "..#L....#",
    "....#....",
    ".........",
    "#........",
    "...#....."
]

test_4_map = [
    ".............",
    ".L.L.#.#.#.#.",
    "............."
]

number_seated seat_map