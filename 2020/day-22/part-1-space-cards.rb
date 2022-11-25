require_relative '../helper'
include Helper

test_data = File.read("day-22/test-data.txt")
cards_data = File.read("day-22/moves-data.txt")

def space_cards cards_data
    player_1, player_2 = cards_data.split(/\n\n/)
    player_1_cards = player_1.split(/\n/)[1..-1].map(&:to_i)
    player_2_cards = player_2.split(/\n/)[1..-1].map(&:to_i)
    game_over = false

    loop do
        player_1_card = player_1_cards.shift
        player_2_card = player_2_cards.shift

        if player_1_card > player_2_card
            card_pile = [player_1_card, player_2_card]
            player_1_cards += card_pile
        else
            card_pile = [player_2_card, player_1_card]
            player_2_cards += card_pile
        end

        if player_1_cards.empty? || player_2_cards.empty?
            game_over = true
        end

        break if game_over
    end

    p player_1_cards.empty? ? calculate_score(player_2_cards) : calculate_score(player_1_cards)
       
end

def calculate_score(cards)
    cards.reverse!
    cards.each_with_index.map { |card, index| card * (index + 1) }.sum
end

space_cards(cards_data)