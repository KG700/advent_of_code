test_input = 389125467
actual_input = 962713854

def crab_cups input
    game_input = input.to_s.split("").map(&:to_i).reverse!
    game_input = game_input + (game_input.max + 1).upto(1000000).to_a
    max_value = game_input.max

    10000000.times do
        game_input
        current_cup = game_input.pop
        pick_up_cups = game_input.pop(3)
        destination_cup = nil
        search_value = ((current_cup - 1) - 1) % max_value + 1
        max_value.times do
            if game_input.include?(search_value)
                destination_cup = search_value
                break
            end
            search_value = ((search_value - 1) - 1) % max_value + 1
        end
        destination_index = (game_input.find_index(destination_cup)) % max_value
        game_input.insert(destination_index, pick_up_cups[0], pick_up_cups[1], pick_up_cups[2])
        game_input.unshift(current_cup)
    end

    index = game_input.find_index(1)
    first_num = game_input[(index - 1) % max_value]
    second_num = game_input[(index - 2) % max_value]
    # p game_input
    p first_num
    p second_num
    p first_num * second_num
    # final_order = []
    # (game_input.length - 1).times do
    #     index = (index - 1) % max_value
    #     final_order.push(game_input[index])
    # end
    # p final_order.join

end

crab_cups(actual_input)