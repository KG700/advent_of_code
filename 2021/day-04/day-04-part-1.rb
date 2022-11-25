require_relative '../helper'
include Helper

bingo_data = Helper::upload("day-04/part-1-input.txt")
# bingo_test_data = Helper::upload("day-04/test-input.txt")

def find_winning_board bingo_data

    random_numbers = bingo_data[0].split(",")

    bingo_boards_array = bingo_data.drop(1).each_slice(6).to_a
    bingo_boards = bingo_boards_array.map do |board|
        board = board.map { |row| row.split(" ")}.flatten
        board = board.map { |number| {:value => number, :marked => false} }
    end
    winning_board = []
    winning_number = nil
    random_numbers.each do |bingo_number|
        bingo_boards = bingo_boards.map do |board| 
            board = board.each do |board_number| 
                board_number[:marked] = true if bingo_number === board_number[:value]
            end
        end
        winning_board = bingo_boards.select {|board| winning_board? board}

        winning_number = bingo_number if winning_board.length > 0
        break if winning_board.length > 0
    end

    unwinning_numbers_sum = winning_board[0].reduce(0) do |sum, num| 
        to_add = num[:marked] ? 0 : num[:value].to_i
        sum + to_add
    end
    p unwinning_numbers_sum * winning_number.to_i
end

WINNING_COMBINATIONS = [
    [0,1,2,3,4], 
    [5,6,7,8,9], 
    [10,11,12,13,14], 
    [15,16,17,18,19],
    [20,21,22,23,24],
    [0,5,10,15,20],
    [1,6,11,16,21],
    [2,7,12,17,22],
    [3,8,13,18,23],
    [4,9,14,19,24]
]

def winning_board? board
    is_winner = false
    WINNING_COMBINATIONS.each do |combination|
        a, b, c, d, e = combination
        if board[a][:marked] && board[b][:marked] && board[c][:marked] && board[d][:marked] && board[e][:marked]
            is_winner = true
        end
        break if is_winner
    end
    is_winner
end

find_winning_board bingo_data