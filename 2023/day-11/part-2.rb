require_relative '../helper'
include Helper

data = Helper::upload("2023/day-11/input.txt")
data_test = Helper::upload("2023/day-11/input-test.txt")

EXPAND_BY = 1000000

def calculate galaxy

   expanded_rows = []
   galaxy.each_with_index { |sky, row| expanded_rows.push(row) if sky.count('#') == 0 }
   
   galaxy = rotate(galaxy)

   expanded_cols = []
   galaxy.each_with_index { |sky, index| expanded_cols.push(index) if sky.count('#') == 0 }

   galaxies = []
   galaxy.each_with_index do |sky_row, row|
      sky_row.chars.each_with_index do |sky, col|
         row_coord = row
         col_coord = col
         expanded_rows.each { |expand| row_coord += EXPAND_BY - 1 if row >= expand }
         expanded_cols.each { |expand| col_coord += EXPAND_BY - 1 if col >= expand }
         galaxies.push("#{row_coord},#{col_coord}") if sky == '#'
      end
   end

   steps = 0
   galaxies.each_with_index do |galaxy, index|
      galaxy_row, galaxy_col = galaxy.split(",").map(&:to_i)
      other_galaxies = galaxies[(index + 1)..-1]
      other_galaxies.each do |other|
         other_row, other_col = other.split(",").map(&:to_i)
         steps += (galaxy_row - other_row).abs + (galaxy_col - other_col).abs
      end
   end

   steps
end


def rotate galaxy
   rotated = []
   height = galaxy.length
   width = galaxy[0].length
   width.times do |w|
      row = ""
      height.times do |h|
         row += galaxy[h][w]
      end
      rotated << row.reverse
   end

   rotated
end

p calculate data