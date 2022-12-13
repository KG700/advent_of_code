require_relative '../helper'
include Helper

data = Helper::upload("2022/day-13/input.txt")
data_test = Helper::upload("2022/day-13/input-test.txt")

DIVIDER_PACKET_1 = [['2']]
DIVIDER_PACKET_2 = [['6']]

def calculate data
    packets = []
    data.each { |packet| packets.push(packet) unless packet.empty? }
    
    packets.map! do |packet| 
        packet, len = create_array packet[1..-1]
        packet
    end

    packets.push(DIVIDER_PACKET_1)
    packets.push(DIVIDER_PACKET_2)

    (packets.length).times do |n|
        (0...(packets.length - 1)).each do |i|
            right_order = compare(packets[i], packets[i + 1])

            unless right_order
                temporary_packet_holder = packets[i]
                packets[i] = packets[i + 1]
                packets[i + 1] = temporary_packet_holder
            end
        end
    end

    divider_key = 1
    packets.each_with_index do |packet, index|
        if packet == DIVIDER_PACKET_1 || packet == DIVIDER_PACKET_2
            divider_key *= (index + 1)
        end
    end
    p divider_key
end

def compare pair_1, pair_2
    is_right_order = nil
    pair_1.each_with_index do |pair, index|
        if index >= pair_2.length 
            return false
        elsif pair.empty? && !pair_2[index].empty?
            return true
        elsif !pair.empty? && pair_2[index].empty?
            return false
        elsif pair.kind_of?(Array) && pair_2[index].kind_of?(Array)
            is_right_order = compare(pair, pair_2[index])
            return is_right_order unless is_right_order.nil?
        elsif pair.kind_of?(Array)
            is_right_order = compare(pair, [pair_2[index]])
            return is_right_order unless is_right_order.nil?
        elsif pair_2[index].kind_of?(Array)
            is_right_order = compare([pair], pair_2[index])
            return is_right_order unless is_right_order.nil?
        elsif pair.to_i != pair_2[index].to_i
            return pair.to_i < pair_2[index].to_i
        end
    end

    if pair_1.length < pair_2.length
        return true
    end
    is_right_order
end

def create_array pair
    pair_array = []
    i = 0
    item = ""
    loop do
        case pair[i]
        when "["
            item, item_length = create_array(pair[(i + 1)..-1])
            i += item_length + 1
        when ","
            pair_array.push(item)
            item = ""
        when ']'
            pair_array.push(item)
            return [pair_array, i]
        else
            item += pair[i]
        end

        break if i >= pair.length - 1
        i += 1
    end
    pair_array
end

calculate data