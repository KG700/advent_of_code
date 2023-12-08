require_relative '../helper'
include Helper

data = Helper::upload("2023/day-07/input.txt")
data_test = Helper::upload("2023/day-07/input-test.txt")

CARDS = ['A', 'K', 'Q', 'T', '9', '8', '7', '6', '5', '4', '3', '2', 'J']
TYPES = [
    'five-of-a-kind', #5
    'four-of-a-kind', #41
    'full-house', #32
    'three-of-a-kind', #311
    'two-pair', #221
    'one-pair', #2111
    'high-card' #11111
]

CODE_TO_TYPE = {
    5 => 'five-of-a-kind',
    41 => 'four-of-a-kind',
    32 => 'full-house',
    311 => 'three-of-a-kind',
    221 => 'two-pair',
    2111 => 'one-pair',
    11111 => 'high-card'
}

def calculate data
    hands = Hash.new { |h,k| h[k] = [] }

    data.each do |round|
        hand, bid = round.split(" ")
        hand_type = get_hand_type hand
        p hand_type
        hand_info = { 'hand' => hand, 'bid' => bid } 
        hands[hand_type].push(hand_info)
    end

    score = 0
    rank = data.length

    TYPES.each do |type|
        sorted_hands = merge_sort(hands[type])
        sorted_hands.each_with_index do |hand| 
            score += hand['bid'].to_i * rank
            rank -= 1
        end
    end

    score
end

def get_hand_type hand
    code = []
    jokers = hand.count('J')

    CARDS.each do |card|
        next if card == 'J'
        count = hand.count(card)
        code.push(count) if count > 0
    end

    code = code.sort.reverse
    code[0] += jokers if code.length > 0
    code[0] = jokers if code.length == 0
    CODE_TO_TYPE[code.join.to_i]
end

def merge_sort(unsorted_array) 
    return unsorted_array if unsorted_array.length <= 1

    mid = unsorted_array.length/2
    left = merge_sort(unsorted_array.slice(0...mid))
    right = merge_sort(unsorted_array.slice(mid...unsorted_array.length))
    
    sorted = []

    until left.empty? || right.empty?
      if highest_rank(left[0]['hand'], right[0]['hand']) == left[0]['hand']
        sorted.push(left.shift)
      else
        sorted.push(right.shift)
      end
    end
  
    sorted.concat(left).concat(right)
end

def highest_rank hand_1, hand_2

    5.times do |card|
        if CARDS.find_index(hand_1[card]) > CARDS.find_index(hand_2[card])
            return hand_2
        elsif CARDS.find_index(hand_2[card]) > CARDS.find_index(hand_1[card])
            return hand_1
        end
    end
end

p calculate data