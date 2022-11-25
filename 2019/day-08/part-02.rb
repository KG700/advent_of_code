require_relative '../helper'
include Helper

image_data = Helper::upload("2019/day-08/input.txt")

def find_layer data
    data = data[0].split("")
    data = data.each_slice(25 * 6).to_a

    image = []
    (25 * 6).times do |i|
        data.each do |layer|
            if layer[i] != "2"
                image.push("X") if layer[i] == "1"
                image.push(".") if layer[i] == "0"
                break
            end
        end
    end
    
    image.each_slice(25) {|width| p width.join("") }

end

find_layer image_data