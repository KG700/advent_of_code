require 'set'
require_relative '../helper'
include Helper

data = Helper::upload("2023/day-16/input.txt")
data_test = Helper::upload("2023/day-16/input-test.txt")

# TODO:
# Find bug that's causing an infinite loop for top entry points
# Optimise by creating a hash:
#    - format: { <tile> => { 'R' => <num>, 'L' => <num>, etc }, etc }
#    - check at start of get_energised methood and return if num exists
#    - update at end of get_energised methood if num didn't exist
#    - will only initialise a single instance of contraption
#    - to find out max will check hash for each edge entry

def calculate data
   max_tiles = 0
   
   data.each_with_index do |line, row|
      entry = "#{row},0"
      direction = "R"
      contraption = Contraption.new(data)
      contraption.get_energised(entry, direction)
      contraption.energised.length
      max_tiles = [contraption.energised.length, max_tiles].max
   end

   data.each_with_index do |line, row|
      entry = "#{row},#{data.length - 1}"
      direction = "L"
      contraption = Contraption.new(data)
      contraption.get_energised(entry, direction)
      contraption.energised.length
      max_tiles = [contraption.energised.length, max_tiles].max
   end

   # data[0].chars.each_with_index do |line, col|
   #    entry = "0,#{col}"
   #    direction = "D"
   #    contraption = Contraption.new(data)
   #    contraption.get_energised(entry, direction)
   #    contraption.energised.length
   #    max_tiles = [contraption.energised.length, max_tiles].max
   # end

   data[0].chars.each_with_index do |line, col|
      entry = "#{data[0].length - 1},#{col}"
      direction = "U"
      contraption = Contraption.new(data)
      contraption.get_energised(entry, direction)
      contraption.energised.length
      max_tiles = [contraption.energised.length, max_tiles].max
   end

   max_tiles
end

class Contraption

   attr_reader :energised

   def initialize tiles
      @tiles = tiles
      @energised = Set.new
      @visited = []
   end

   def get_energised tile, direction
      return if self.blocked? tile, direction
      @energised << tile
      row, col = tile.split(",").map(&:to_i)
      tile_type = @tiles[row][col]
      @visited << "#{direction}:#{tile}"
      
      self.get_next_directions(tile_type, direction).each do |next_direction|
         next_tile = self.get_next_tile(tile, next_direction)
         self.get_energised(next_tile, next_direction)
      end
   end

   def get_next_directions tile_type, direction
      case direction
      when 'R'
         return ['U','D'] if tile_type == '|'
         return ['D'] if tile_type == '\\'
         return ['U'] if tile_type == '/'
         return ['R']
      when 'D'
         return ['L','R'] if tile_type == '-'
         return ['R'] if tile_type == '\\'
         return ['L'] if tile_type == '/'
         return ['D']
      when 'L'
         return ['U','D'] if tile_type == '|'
         return ['U'] if tile_type == '\\'
         return ['D'] if tile_type == '/'
         return ['L']
      when 'U'
         return ['L','R'] if tile_type == '-'
         return ['L'] if tile_type == '\\'
         return ['R'] if tile_type == '/'
         return ['U']
      end
   end

   def get_next_tile tile, direction
      row, col = tile.split(",").map(&:to_i)

      case direction
      when 'R'
         return "#{row},#{col + 1}"
      when 'D'
         return "#{row + 1},#{col}"
      when 'L'
         return "#{row},#{col - 1}"
      when 'U'
         return "#{row - 1},#{col}"
      end
   end

   def blocked? tile, direction
      row, col = tile.split(",").map(&:to_i)
      row < 0 || row >= @tiles.length || col < 0 || col >= @tiles[0].length || @visited.include?("#{direction}:#{tile}")
   end

end

p calculate data