require_relative '../helper'
include Helper

seqment_data = Helper::upload("2021/day-08/part-1-input.txt")
# seqment_test_data = Helper::upload("2021/day-08/test-input.txt")

def count_seqments seqment_data
    seqment_data = seqment_data.map do |seq| 
        seq.split(" | ").map { |digit| digit.split(" ") }
    end

    count_specific_length = 0
    seqment_data.each do |seq|
        seq[1].each do |digit|
            count_specific_length += 1 if [2,3,4,7].include? digit.length
        end
    end
    p count_specific_length

end

count_seqments seqment_data