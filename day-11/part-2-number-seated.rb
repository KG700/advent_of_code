
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
                    next_map[r][c] = seat if seat == "."
                else
                    adjacent_seats = visible_seats(r,c, seat_map)
                    row_changed = (seat == "L" && adjacent_seats.count('#') == 0) || (seat == "#" && adjacent_seats.count('#') >= 5)
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

def visible_seats r, c, map
    seats = []

    # check right
    if c < map[0].length - 1
        ((c + 1)...map[0].length).each do |col|
            if map[r][col] != '.'
                seats.push(map[r][col])
                break
            end
        end
    end

    # check diagonal right-down
    if r < map.length - 1 && c < map[0].length - 1
        edge = [map.length - r - 1, map[0].length - c - 1].min

        (1..edge).each do |x|
            if map[r + x][c + x] != '.'
                seats.push(map[r + x][c + x])
                break
            end
        end
    end

    # check down
    if r < map.length - 1
        ((r + 1)...map.length).each do |row|
            if map[row][c] != '.'
                seats.push(map[row][c])
                break
            end
        end
    end

    # check diagonal left-down
    if r < map.length - 1 && c > 0
        edge = [map.length - r - 1, c].min

        (1..edge).each do |x|
            if map[r + x][c - x] != '.'
                seats.push(map[r + x][c - x])
                break
            end
        end
    end

    # check left
    if c > 0
        (c - 1).downto(0).each do |col|
            if map[r][col] != '.'
                seats.push(map[r][col])
                break
            end
        end
    end

    # check diagonal left-up
    if c > 0 && r > 0
        edge = [r, c].min

        (1..edge).each do |x|
            if map[r - x][c - x] != '.'
                seats.push(map[r - x][c - x])
                break
            end
        end
    end

    # check up
    if r > 0
        (r - 1).downto(0).each do |row|
            if map[row][c] != '.'
                seats.push(map[row][c])
                break
            end
        end
    end

    # check diagonal right-up
    if c < map[0].length - 1 && r > 0
        edge = [r, map[0].length - c - 1].min

        (1..edge).each do |x|
            if map[r - x][c + x] != '.'
                seats.push(map[r - x][c + x])
                break
            end
        end
    end
    return seats
end

def upload file
    file = File.open(file)
    file_data = file.readlines.map(&:chomp)
    file.close
    file_data
end

seat_map = upload("day-11/seating-data.txt")

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