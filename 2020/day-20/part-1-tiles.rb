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

    p completed_grid.product_of_corners
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
        tile.dup,
        tile.dup.rotate,
        tile.dup.rotate.rotate,
        tile.dup.rotate.rotate.rotate,
        tile.dup.flip,
        tile.dup.flip.rotate,
        tile.dup.flip.rotate.rotate,
        tile.dup.flip.rotate.rotate.rotate
    ]
end

jurassic_jigsaw(tile_data)