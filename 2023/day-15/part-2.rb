require_relative '../helper'
include Helper

data = Helper::upload("2023/day-15/input.txt")
data_test_1 = Helper::upload("2023/day-15/input-test-1.txt")
data_test_2 = Helper::upload("2023/day-15/input-test-2.txt")

def calculate data
   input_strings = data[0].split(",")
   boxes = Hash.new {|h,k| h[k] = [] }

   input_strings.each do |input_string|
      is_equals_operation = input_string.include? '='
      label = ''

      if is_equals_operation
         label, number = input_string.split('=')
         box_hash = get_hash(label)

         lens_index = find_lens(boxes[box_hash], label)
         if lens_index
            boxes[box_hash][lens_index] = { :label => label, :number => number.to_i }
         else
            boxes[box_hash].push({ :label => label, :number => number.to_i })
         end
      else
         label = input_string[0...-1]
         box_hash = get_hash(label)
         lens_index = find_lens(boxes[box_hash], label)
         boxes[box_hash].delete_at(lens_index) if lens_index
      end

   end

   focussing_power = 0
   boxes.each do |box, lenses|
      lenses.each_with_index do |lens, index| lens[:number]
         focussing_power += (box + 1) * (index + 1) * lens[:number]
      end
   end

   focussing_power

end

def get_hash label
   number = 0
   label.chars.each do |char|
      number = (number + char.ord) * 17 % 256
   end
   number
end

def find_lens lenses, label
   lens_index = nil
   lenses.each_with_index { |lens, index| lens_index = index if lens[:label] == label }
   lens_index
end

p calculate data