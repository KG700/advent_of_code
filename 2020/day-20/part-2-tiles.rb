require_relative '../helper'
include Helper

tile_data = File.read("2020/day-20/tile-data.txt")
test_data = File.read("2020/day-20/test-data.txt")

class Grid
    attr_reader :grid, :size
    def initialize size
        @grid = Array.new(size) { |row| Array.new(size) }
        @size = size
    end

    def valid_tile? tile, dimensions
        x, y = dimensions
        
        top_tile = @grid[x - 1] ? @grid[x - 1][y] : nil
        bottom_tile =  @grid[x + 1] ? @grid[x + 1][y] : nil
        left_tile = @grid[x] ? @grid[x][y - 1] : nil
        right_tile = @grid[x] ? @grid[x][y + 1] : nil

        (top_tile.nil? || top_tile.bottom == tile.top) &&
        (bottom_tile.nil? || bottom_tile.top == tile.bottom) &&
        (left_tile.nil? || left_tile.right == tile.left) &&
        (right_tile.nil? || right_tile.left == tile.right)
    end

    def add tile, dimensions
        x, y = dimensions
        @grid[x][y] = tile
    end

    def remove dimensions
        x, y = dimensions
        @grid[x][y] = nil
    end

    def construct_big_tile
        big_tile = []
        tile_size = @grid[0][0].pattern_without_border.length
        @grid.each { |row| row.each { |tile| tile.orient_pattern } }

        @grid.each do |row|
            tile_size.times do |n|
                row_string = ""
                row.each do |tile|
                    row_string += tile.pattern_without_border[n]
                end
                big_tile.push(row_string)
            end
        end
        return big_tile
    end

    def product_of_corners
        raise StandardError.new "Top left-hand corner is nil" if @grid.first.first.nil?
        raise StandardError.new "Top right-hand corner is nil" if @grid.first.last.nil?
        raise StandardError.new "Bottom left-hand corner is nil" if @grid.last.first.nil?
        raise StandardError.new "Bottom right-hand corner is nil" if @grid.last.last.nil?

        @grid.first.first.id * @grid.first.last.id * @grid.last.first.id * @grid.last.last.id
    end
end

class Tile
    ORIENTATIONS = ['0', '90', '180', '270']
    attr_reader :id, :orientation, :flipped, :pattern

    def initialize id, pattern
        @id = id
        @pattern = pattern
        @border = {
            top: @pattern.first,
            bottom: @pattern.last,
            left: @pattern.map { |row| row.chars.first }.join,
            right: @pattern.map { |row| row.chars.last }.join
        }
        @orientation = '0'
        @flipped = false
    end

    def rotate
        current_orientation_index = ORIENTATIONS.index(@orientation)
        @orientation = ORIENTATIONS[(current_orientation_index + 1) % ORIENTATIONS.length]

        @border = {
            top: @border[:left].reverse,
            bottom: @border[:right].reverse,
            left: @border[:bottom],
            right: @border[:top]
        }
        self
    end

    def flip
        @flipped = !@flipped
        @border = {
            top: @border[:top].reverse,
            bottom: @border[:bottom].reverse,
            left: @border[:right],
            right: @border[:left] 
        }
        self
    end

    def top
        @border[:top]
    end

    def bottom
        @border[:bottom]
    end

    def left
        @border[:left]
    end

    def right
        @border[:right]
    end

    def orient_pattern
        flip_pattern if @flipped
        rotate_pattern
    end

    def pattern_without_border
        pattern_without_border = @pattern[1..-2].map { |row| row[1..-2] }
    end

    def rotate_pattern
        current_orientation_index = ORIENTATIONS.index(@orientation)
        
        current_orientation_index.times do
            @pattern = @pattern.each_with_index.map do |row, index| 
                @pattern.map do |select_from_row| 
                    select_from_row.chars[index]
                end.join.reverse
            end
        end
        self
    end

    def flip_pattern
        @pattern = @pattern.map { |row| row.reverse }
        self
    end
end

class Scanner
    SEA_MONSTER = [
        /^..................(#|O).$/,
        /^(#|O)....(#|O)(#|O)....(#|O)(#|O)....(#|O)(#|O)(#|O)$/,
        /^.(#|O)..(#|O)..(#|O)..(#|O)..(#|O)..(#|O)...$/
    ]

    attr_reader :sea_monsters_found
    def initialize tile
        @tile = tile
        @sea_monsters_found = 0
    end

    def scan
        (@tile.pattern.length - 3).times do |row|
            (@tile.pattern[row].length - 20).times do |n|
                segment = [
                    @tile.pattern[row + 0][n...(n + 20)],
                    @tile.pattern[row + 1][n...(n + 20)],
                    @tile.pattern[row + 2][n...(n + 20)]
                ]
                @sea_monsters_found += 1 if contains_monster?(segment)
            end
        end
    end

    def contains_monster? segment
        !!segment[0].match(SEA_MONSTER[0]) &&
        !!segment[1].match(SEA_MONSTER[1]) &&
        !!segment[2].match(SEA_MONSTER[2])
    end
end

def jurassic_jigsaw data
    tiles = data.split(/\n\n/)
    tiles = tiles.map do |tile| 
        this_tile = tile.split(/:\n/)
        tile_id = this_tile[0].scan(/\d+/)[0].to_i
        tile_pattern = this_tile[1].split(/\n/)
        Tile.new(tile_id, tile_pattern)
    end

    grid = Grid.new(Math.sqrt(tiles.length))
    completed_grid = arrange_tiles(tiles, grid)
    big_tile_pattern = completed_grid.construct_big_tile
    number_of_hashes = 0
    big_tile_pattern.each { |row| number_of_hashes += row.count("#") }

    big_tile = Tile.new("big_tile", big_tile_pattern)
    oriented_big_tiles = tiles_to_check(big_tile)
    
    oriented_big_tiles.each do |tile|
        tile.orient_pattern
        find_sea_monsters = Scanner.new(tile)
        find_sea_monsters.scan
        if find_sea_monsters.sea_monsters_found > 0
            p number_of_hashes - find_sea_monsters.sea_monsters_found * 15
            break
        end
    end

end

def arrange_tiles tiles, grid, position = [0,0]
    return grid if tiles.length == 0

    copied_grid = grid.dup
    tiles.each do |tile|

        tiles_to_check(tile).each do |tile_orientation|
            if copied_grid.valid_tile?(tile_orientation, position)
                copied_grid.add(tile_orientation, position)
                next_y = (position[1] + 1) % copied_grid.size
                next_x = next_y == 0 ? position[0] + 1 : position[0]
                remaining_tiles = tiles.select { |tile| tile.id != tile_orientation.id }
                completed_grid = arrange_tiles(remaining_tiles, copied_grid, [next_x, next_y]) 
                return completed_grid unless completed_grid.nil?
                copied_grid.remove(position)
            end
        end
    end
    nil
end

def tiles_to_check tile
    [
        tile.dup.flip,
        tile.dup.flip.rotate,
        tile.dup.flip.rotate.rotate,
        tile.dup.flip.rotate.rotate.rotate,
        tile.dup,
        tile.dup.rotate,
        tile.dup.rotate.rotate,
        tile.dup.rotate.rotate.rotate,
    ]
end

jurassic_jigsaw(tile_data)
