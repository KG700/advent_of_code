# INPUT_RANGE = "256310-732736"

INPUT_RANGE = "256666-732736"

def find_passwords

    start_number, final_number = INPUT_RANGE.split("-")
    p start_number
    p final_number


    valid_passwords = 0

    current_number = "256666"
    
    while current_number.to_i < final_number.to_i do
    # 1. find index
        index = 5
        loop do
            # p current_number[index]
            if current_number[index] == "9"
                index -= 1
                break if index < 0
            else
                break
            end
        end
        
        # 2. add 1 to value at that index an apply to all numbers indexes after
        new_number = (current_number[index].to_i + 1).to_s
        (index..5).each {|i| current_number[i] = new_number }
        
        # 3. check if current_number has any double digits
        if contains_double_digits?(current_number)
            valid_passwords += 1
        end

        # i. if yes - add to array (for now. will switch to count when it's working)
    end
    p valid_passwords

end

def contains_double_digits? number
    has_double_digits = false
    (0...number.length).each do |index|
        has_double_digits = number[index] == number[index + 1]
        break if has_double_digits
    end
    has_double_digits
end

find_passwords