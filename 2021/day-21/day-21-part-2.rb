# Test
# Player 1 starting position: 4
# Player 2 starting position: 8

# Actual
# Player 1 starting position: 7
# Player 2 starting position: 2

DICE_COMBINATIONS = [
    { :total => 3, :multiplier => 1 },
    { :total => 4, :multiplier => 3 },
    { :total => 5, :multiplier => 6 },
    { :total => 6, :multiplier => 7 },
    { :total => 7, :multiplier => 6 },
    { :total => 8, :multiplier => 3 },
    { :total => 9, :multiplier => 1 },
]

def play_dirac_dice
    
    player = 0
    game_board = "7,2"
    scores = "0,0"
    wins = [0,0]

    DICE_COMBINATIONS.each do |dice|
        play_game(dice[:total], player, game_board, scores, wins, dice[:multiplier])
    end

    p wins
  
end

def play_game(dice_total, player, game_board, scores, wins, multiplier)

    game_board_p1 = game_board[/([^,]+)/]
    game_board_p2 = game_board[/[^,]*$/]
    score_p1 = scores[/([^,]+)/].to_i
    score_p2 = scores[/[^,]*$/].to_i

    if player === 0
        game_board_p1 = calculate_game_board(game_board_p1, dice_total)
        score_p1 = score_p1.to_i + game_board_p1
    else
        game_board_p2 = calculate_game_board(game_board_p2, dice_total)
        score_p2 = score_p2 + game_board_p2
    end

    if score_p1 >= 21 || score_p2 >= 21
        wins[player] += 1 * multiplier
        return wins
    end

    next_player = (player + 1) % 2
    updated_game_board = "#{game_board_p1},#{game_board_p2}"
    updated_scores = "#{score_p1},#{score_p2}"

    DICE_COMBINATIONS.each do |dice|
        play_game(dice[:total], next_player, updated_game_board, updated_scores, wins, dice[:multiplier] * multiplier)
    end

end

def calculate_game_board(current_game_board, dice_total)
    (current_game_board.to_i + dice_total - 1) % 10 + 1
end

play_dirac_dice