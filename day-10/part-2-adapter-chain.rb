def adapter_chain adapters
    adapters.push(0).sort!

    jolts = { 1 => 0, 2=>0, 3 => 1}
    
    adapters.each_cons(2) { |j1, j2| jolts[(j2-j1)] += 1 }
    p jolts[1] * jolts[3]
    
end

def all_adapter_chains adapters
    adapters.push(0).sort!
    p adapters

    combinations = [0, 0]
    adapters[2] - adapters[0] <= 3 ? combinations.push(1) : combinations.push(0)
    # adapters[3] - adapters[0] <= 3 ? combinations.push(2) : combinations.push(0)
    adapters.each_with_index do |num, index| 
        sum = 0
        if index > 2
            if num - adapters[index - 2] <= 3
                sum += 1
                combinations[0..-2].each { |x| sum += x }
            end
            if num - adapters[index - 3] <= 3
                sum += 1
                combinations[0..-3].each { |x| sum += x }
            end
            combinations.push(sum)
        end
    end

    p combinations.inject(0){|sum,x| sum + x } + 1
    
end


def upload file
    file = File.open(file)
    file_data = file.readlines.map(&:chomp)
    file.close
    file_data
end

jolt_data = upload("day-10/jolt-data.txt").map(&:to_i)
test_1_data = [16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4]
test_2_data = [28, 33, 18, 42, 31, 14, 46, 20, 48, 47, 24, 23, 49, 45, 19, 38, 39, 11, 1, 32, 25, 35, 8, 17, 7, 9, 4,2, 34, 10, 3]

all_adapter_chains jolt_data
