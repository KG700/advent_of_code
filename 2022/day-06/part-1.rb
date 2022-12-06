require_relative '../helper'
include Helper

data = Helper::upload("2022/day-06/input.txt")
data_test = Helper::upload("2022/day-06/input-test.txt")

UNIQUE_NUMBER = 4

def calculate datastream
    start_of_packet = 0
    ((UNIQUE_NUMBER - 1)..datastream.length).each do |i|
        unique_characters = datastream[(i - UNIQUE_NUMBER + 1)..i].chars.to_a.uniq
        start_of_packet = i + 1 if unique_characters.length == UNIQUE_NUMBER
        break unless start_of_packet.zero?
    end

    p start_of_packet
end

def run_test_examples data_test
    data_test.each { |data| calculate data }
end

# run_test_examples data_test

calculate data[0]