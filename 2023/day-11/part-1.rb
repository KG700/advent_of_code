require_relative '../helper'
include Helper

data = Helper::upload("2023/day-11/input.txt")
data_test = Helper::upload("2023/day-11/input-test.txt")

def calculate data
   half_expanded_galaxy = []
   data.each do |sky|
      half_expanded_galaxy << '.' * sky.length if sky.count('#') == 0
      half_expanded_galaxy << sky
   end

   half_expanded_galaxy = rotate(half_expanded_galaxy)
   expanded_galaxy = []
   half_expanded_galaxy.each_with_index do |sky|
      expanded_galaxy << '.' * sky.length if sky.count('#') == 0
      expanded_galaxy << sky
   end

   galaxies = []
   expanded_galaxy.each_with_index do |sky_row, row|
      sky_row.chars.each_with_index { |sky, col| galaxies.push("#{row},#{col}") if sky == '#' }
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