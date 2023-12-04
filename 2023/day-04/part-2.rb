require_relative '../helper'
include Helper

data = Helper::upload("2023/day-04/input.txt")
data_test = Helper::upload("2023/day-04/input-test.txt")

def calculate data
    cards = {}
    data.reduce(0) do |points, card|
        card, numbers = card.split(": ")
        card_number = card.split(" ")[1].to_i
        winning_numbers, my_numbers = numbers.split(" | ")
        matching_numbers = winning_numbers.split(" ").reduce(0) { |count, number| count + (my_numbers.split(" ").include?(number) ? 1 : 0) }
        cards[card_number] = { won_cards: ((card_number + 1)..(card_number + matching_numbers)).to_a }
    end
    
    count = 0
    cards.each { |card, info| count += update_card(card, cards) }
    count

end

def update_card(card_number, cards)
    return 1 if cards[card_number][:won_cards].length == 0

    cards[card_number][:won_cards].reduce(1) { |count, card| count + update_card(card, cards) }
end

p calculate data