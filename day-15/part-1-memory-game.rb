
test_1_numbers = [0,3,6] # 436
test_2_numbers = [1,3,2] # 1
test_3_numbers = [2,1,3] # 10
test_4_numbers = [1,2,3] # 27
test_5_numbers = [2,3,1] # 78
test_6_numbers = [3,2,1] # 438
test_7_numbers = [3,1,2] # 1836

start_numbers = [18,8,0,5,4,1,20]

def find_nth_number(start_numbers, n)
    history = {}
    turn = 1
    number = nil

    loop do
        if turn <= start_numbers.length
            number = start_numbers[turn - 1]
            history[number] = { "turn-1" => turn, "turn-2" => nil }
        else
            if history[number]["turn-2"].nil?
                number = 0
            else
                number = history[number]["turn-1"] - history[number]["turn-2"]
            end
            if history.key?(number)
                history[number]["turn-2"] = history[number]["turn-1"]
                history[number]["turn-1"] = turn
            else
                history[number] = { "turn-1" => turn, "turn-2" => nil }
            end
        end

        break if turn == n
        turn += 1
    end
    # p history
    p number
    
end

find_nth_number(start_numbers, 30000000)