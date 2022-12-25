require_relative '../helper'
include Helper

data = Helper::upload("2022/day-21/input.txt")
data_test = Helper::upload("2022/day-21/input-test.txt")

def calculate data

    operations = {}
    numbers = {}
    root = []

    jobs = data.map { |monkey| monkey.split(": ") }
    jobs.each do |monkey_job|
        monkey, job = monkey_job
        if monkey == 'root'
            root = job.scan(/\w+/)
        elsif job.include?(" ")
            operations[monkey] = {
                op: job,
                dep: job.scan(/\w+/)
            }
        elsif monkey != 'humn'
            numbers[monkey] = job.to_i
        end
    end

    operations, numbers = solve(operations, numbers)

    monkey = numbers[root[0]].nil? ? root[0] : root[1]
    number = numbers[root[0]].nil? ? numbers[root[1]] : numbers[root[0]]
    numbers[monkey] = number

    operation = operations[monkey]

    loop do
        monkey, number = reverse_solve(numbers, operation, number)
        numbers[monkey] = number
        break if monkey == 'humn'

        operation = operations[monkey]

    end
    
    p numbers['humn']

end

def solve operations, numbers
    loop do
        operations_to_solve = operations.select { |monkey, operation| (operation[:dep] - numbers.keys).empty? }
        break if operations_to_solve.empty?

        operations_to_solve.each do |monkey, operation|
            first_num, operator, second_num = operation[:op].split(" ")
            first_num = numbers[first_num]
            second_num = numbers[second_num]

            case operator
            when "+"
                numbers[monkey] = first_num + second_num
            when "-"
                numbers[monkey] = first_num - second_num
            when "*"
                numbers[monkey] = first_num * second_num
            when "/"
                numbers[monkey] = first_num / second_num
            else
                throw "Error: operator not found"
            end
            operations.delete(monkey)
        end
    end
    [operations, numbers]
end

def reverse_solve numbers, operation, result
    first_monkey, operator, second_monkey = operation[:op].split(" ")
    operation_number = numbers[first_monkey].nil? ? numbers[second_monkey] : numbers[first_monkey]
    monkey_to_solve = numbers[first_monkey].nil? ? first_monkey : second_monkey

    number = nil
    
    case operator
    when "+"
        number = result - operation_number
    when "-"
        if numbers[first_monkey] == operation_number 
            number = operation_number - result
        else
            number = result + operation_number
        end
    when "*"
        number = result / operation_number
    when "/"
        if numbers[first_monkey] == operation_number
            number = operation_number / result
        else
            number = result * operation_number
        end
    else
        throw "Error: operator not found"
    end

    [monkey_to_solve, number]
end

calculate data