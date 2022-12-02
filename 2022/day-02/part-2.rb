require_relative '../helper'
include Helper

data = Helper::upload("2022/day-02/input.txt")
data_test = Helper::upload("2022/day-02/input-test.txt")

SCORING = {'rock' => 1, 'paper' => 2, 'scissors' => 3}
SHAPE_MAP = {'A' => 'rock', 'B' => 'paper', 'C' => 'scissors'}
SHAPE_TO_WIN = {'scissors' => 'rock', 'paper' => 'scissors', 'rock' => 'paper'}
SHAPE_TO_LOSE = SHAPE_TO_WIN.invert

def tournament data
    score = data.reduce(0) do |score, round|
        my_move = get_next_move round

        round_score = SCORING[my_move]
        round_score += 6 if round[-1] == 'Z'
        round_score += 3 if round[-1] == 'Y'
        score += round_score
    end
    p score
end

def get_next_move round
    reindeers_move = SHAPE_MAP[round[0]]
    case round[-1]
        when 'X'
            return SHAPE_TO_LOSE[reindeers_move] 
        when 'Y'
            return reindeers_move
        when 'Z'
            return SHAPE_TO_WIN[reindeers_move]
        else
            throw "Error"
    end
end

tournament data