require_relative '../helper'
include Helper

data = Helper::upload("2022/day-02/input.txt")
data_test = Helper::upload("2022/day-02/input-test.txt")

SCORING = {'rock' => 1, 'paper' => 2, 'scissors' => 3}
SHAPE_MAP = {'A' => 'rock', 'B' => 'paper', 'C' => 'scissors', 'X' => 'rock', 'Y' => 'paper', 'Z' => 'scissors'}
SHAPE_TO_WIN = {'scissors' => 'rock', 'paper' => 'scissors', 'rock' => 'paper'}

def tournament data
    score = data.reduce(0) do |score, round|
        my_move = SHAPE_MAP[round[-1]]
        reindeers_move = SHAPE_MAP[round[0]]
        move_to_win = SHAPE_TO_WIN[reindeers_move]

        round_score = SCORING[my_move]
        round_score += 6 if move_to_win == my_move
        round_score += 3 if reindeers_move ==  my_move
        score += round_score
    end
    p score
end

tournament data