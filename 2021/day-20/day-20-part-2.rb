require_relative '../helper'
include Helper

image_data = Helper::upload("day-20/input.txt")
image_data_test = Helper::upload("day-20/test-input.txt")

def scan_image image_data

    image_enhancement_algorithm = image_data[0]
    input_image = image_data[2..-1]
    
    50.times do |n|

        zero = (n + 1).odd? ? "." : "#"
        
        image_size = input_image.length
        input_image.unshift("#{zero}"*image_size).unshift("#{zero}"*image_size)
        input_image.push("#{zero}"*image_size).push("#{zero}"*image_size)
        input_image = input_image.map {|row| "#{zero}#{zero}#{row}#{zero}#{zero}"}
        output_image = []

        input_image.each_with_index do |row, row_index|
            output_image_row = []
            row.split("").each_with_index do |pixel, pixel_index|
                pixel_string = get_pixel_string(row_index, pixel_index, input_image, zero)
                pixel_binary = pixel_string.gsub(".", "0").gsub("#", "1")
                pixel_index = Helper::to_decimal(pixel_binary)
                output_pixel = image_enhancement_algorithm[pixel_index]
                output_image_row.push(output_pixel)

            end
            output_image.push(output_image_row.join)
        end

        input_image = Helper::deep_copy(output_image)
    end

    lit_pixels_count = 0
    input_image.each {|pixels| lit_pixels_count += pixels.count("#")}
    p lit_pixels_count
end

def get_pixel_string row, col, image, zero

    coords = [
        [row - 1, col - 1],
        [row - 1, col],
        [row - 1, col + 1],
        [row, col - 1],
        [row, col],
        [row, col + 1],
        [row + 1, col - 1],
        [row + 1, col],
        [row + 1, col + 1]
    ]
    pixel_string = coords.map do |coord| 
        not_in_range = coord[0] < 0 || coord[1] < 0 || coord[0] >= image.length || coord[1] >= image[1].length
        not_in_range ? "#{zero}" : image[coord[0]][coord[1]]
    end.join
end

scan_image image_data