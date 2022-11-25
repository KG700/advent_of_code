
SUBJECT_NUMBER = 7
DIVIDE_NUMBER = 20201227

test_public_keys = {
    card: 5764801,
    door: 17807724
}

actual_public_keys = {
    card: 6929599,
    door: 2448427
}

def find_encryption_key public_keys

    # 1. Find card & door loop size with trial & error
    #     Set the value to itself multiplied by the subject number.
    #     Set the value to the remainder after dividing the value by 20201227.
    card_loop_size = find_loop_size(public_keys[:card])
    door_loop_size = find_loop_size(public_keys[:door])
    p transform_public_key(public_keys[:door], card_loop_size)


end

def find_loop_size public_key
    loop_size = 0
    value = 1
    loop do 
        value = (value * SUBJECT_NUMBER)
        value = (value % DIVIDE_NUMBER)
        loop_size += 1
        break if value == public_key
    end
    loop_size
end

def transform_public_key public_key, loop_size
    value = 1
    loop_size.times do 
        value = (value * public_key)
        value = (value % DIVIDE_NUMBER)
    end
    return value
end

find_encryption_key(actual_public_keys)