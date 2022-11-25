# Test
# Player 1 starting position: 4
# Player 2 starting position: 8

# Actual
# Player 1 starting position: 7
# Player 2 starting position: 2

def play_deterministic_dice
    
    game_board = [7,2]
    scores = [0,0]
    dice = 1
    rounds = 0

    loop do
        2.times do |player|
            rounds += 1
            roll_total = (dice * 3) + 3
            dice = (dice + 3 - 1) % 100 + 1
            game_board[player] = (game_board[player] + roll_total - 1) % 10 + 1
            scores[player] += game_board[player]

            break if scores.max >= 1000
        
        end
        
        break if scores.max >= 1000

    end

    p scores.min * (rounds * 3)
  
end

play_deterministic_dice