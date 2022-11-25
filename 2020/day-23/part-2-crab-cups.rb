test_input = 389125467
actual_input = 962713854

def crab_cups input
    game_input = input.to_s.split("").map(&:to_i)
    game_input = game_input + (game_input.max + 1).upto(1000000).to_a
    current_cup = game_input.first
    max_value = 1000000
    cups_list = {}
    
    next_cup = nil
    game_input.each_with_index do |cup, index|
        next_cup = (index + 1) < game_input.length ? game_input[index + 1] : game_input.first
        cups_list[cup] = { next: next_cup }
    end
    
    10000000.times do
        pick_up_cups = []
        pick_up_cups.push(cups_list[current_cup][:next])
        pick_up_cups.push(cups_list[pick_up_cups[0]][:next])
        pick_up_cups.push(cups_list[pick_up_cups[1]][:next])

        destination_cup = nil
        search_value = ((current_cup - 1) - 1) % max_value + 1
        5.times do
            unless pick_up_cups.include?(search_value) || search_value == current_cup
                destination_cup = search_value
                break
            end
            search_value = ((search_value - 1) - 1) % max_value + 1
        end
        placeholder_cup = cups_list[destination_cup][:next]
        after_pick_up_cups = cups_list[pick_up_cups[2]][:next]

        cups_list[current_cup][:next] = cups_list[pick_up_cups[2]][:next]
        cups_list[destination_cup][:next] = pick_up_cups[0]
        cups_list[pick_up_cups[2]][:next] = placeholder_cup
        
        current_cup = cups_list[current_cup][:next]
    end

    prev_1_num = cups_list[1][:next]
    prev_2_num = cups_list[prev_1_num][:next]

    p prev_1_num * prev_2_num


end

crab_cups(actual_input)