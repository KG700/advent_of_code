# INPUT_RANGE = "256310-732736"

INPUT_RANGE = "256666-732736"

def find_passwords

    start_number, final_number = INPUT_RANGE.split("-")
    p start_number
    p final_number


    valid_passwords = 0

    current_number = "256666"
    
    while current_number.to_i < final_number.to_i do
        index = 5
        loop do
            if current_number[index] == "9"
                index -= 1
                break if index < 0
            else
                break
            end
        end
        
        new_number = (current_number[index].to_i + 1).to_s
        (index..5).each {|i| current_number[i] = new_number }
        
        if contains_double_digits?(current_number)
            valid_passwords += 1
        end

    end
    p valid_passwords

end

def contains_double_digits? number
    is_pair = false
    (0...number.length).each do |index|
        has_double_digits = number[index] == number[index + 1]
        is_LHS_pair = index == 0 ? true : number[index] != number[index - 1]
        is_RHS_pair = index == number.length - 1 ? true : number[index] != number[index + 2]
        is_pair = has_double_digits && is_LHS_pair && is_RHS_pair
        break if is_pair
    end
    is_pair
end

find_passwords