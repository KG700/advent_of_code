require_relative '../helper'
include Helper

test_data = File.read("day-22/test-data.txt")
test_2_data = File.read("day-22/test_2_data.txt")
cards_data = File.read("day-22/moves-data.txt")

def recursive_combat cards_data
    player_1, player_2 = cards_data.split(/\n\n/)
    player_1_cards = player_1.split(/\n/)[1..-1].map(&:to_i)
    player_2_cards = player_2.split(/\n/)[1..-1].map(&:to_i)

    winner, winning_deck = play_game(player_1_cards, player_2_cards)
    p calculate_score(winning_deck)
end

def calculate_score(cards)
    cards.reverse!
    cards.each_with_index.map { |card, index| card * (index + 1) }.sum
end

def play_game player_1_cards, player_2_cards
    round_winner = 0
    game_winner = 0
    round_history= []
    winning_deck = []
    loop do
       
        if round_history.include? [player_1_cards, player_2_cards]
            game_winner = 1
            winning_deck = player_1_cards + player_2_cards
        else
            round_history.push([player_1_cards[0..-1], player_2_cards[0..-1]])
            player_1_card = player_1_cards.shift
            player_2_card = player_2_cards.shift
  
            if player_1_card <= player_1_cards.length && player_2_card <= player_2_cards.length
                round_winner, winning_deck = play_game(player_1_cards.first(player_1_card), player_2_cards.first(player_2_card))
            else
                round_winner = player_1_card > player_2_card ? 1 : 2
            end

            if round_winner == 1
                card_pile = [player_1_card, player_2_card]
                player_1_cards += card_pile
            else
                card_pile = [player_2_card, player_1_card]
                player_2_cards += card_pile
            end
        end

        if (player_1_cards.empty? || player_2_cards.empty?) && game_winner == 0
            game_winner = player_2_cards.empty? ? 1 : 2
            winning_deck = player_2_cards.empty? ? player_1_cards : player_2_cards
        end
        break if game_winner > 0
    end
    return [game_winner, winning_deck]
    
end

recursive_combat(cards_data)