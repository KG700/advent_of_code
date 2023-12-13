require_relative '../helper'
include Helper

data = Helper::upload_line_break("2023/day-13/input.txt")
data_test = Helper::upload_line_break("2023/day-13/input-test.txt")

def calculate data
   data.reduce(0) do |sum, d|
      ground = d.split(/\n/)

      mirror_columns = search_rows(ground)
      
      mirror_image = mirror_columns.reduce(mirror_columns[0]) { |overlap, column| overlap & column }

      if mirror_image.empty?

         ground = rotate(ground)
         ground = rotate(ground)
         ground = rotate(ground)

         mirror_columns = search_rows(ground)

         mirror_image = mirror_columns.reduce(mirror_columns[0]) { |overlap, column| overlap & column }
         mirror_image[0] *= 100
      end
      sum += mirror_image[0]
   end
end

def find_mirror_images row
   row_length = row.length
   row_columns = []

   (row_length / 2).times do |n|
      left = row[0..n]
      right = row[(n + 1)..(2 * n + 1)]
      row_columns << n + 1 if left == right.reverse
   end

   row_columns
end

def rotate rectangle
   rotated = []
   height = rectangle.length
   width = rectangle[0].length
   width.times do |w|
      row = ""
      height.times do |h|
         row += rectangle[h][w]
      end
      rotated << row.reverse
   end

   rotated
end

def search_rows ground
   mirror_columns = []
   ground.each do |row|
      row_columns = find_mirror_images(row)
                     .concat(find_mirror_images(row.reverse).map! do |column| 
                        row.length - column
                     end
                     )
      mirror_columns << row_columns
   end
   mirror_columns
end

p calculate data