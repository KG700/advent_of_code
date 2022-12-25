require_relative '../helper'
include Helper

data = Helper::upload("2022/day-21/input.txt")
data_test = Helper::upload("2022/day-21/input-test.txt")

def calculate data

    operations = {}
    numbers = {}

    jobs = data.map { |monkey| monkey.split(": ") }
    jobs.each do |monkey_job|
        monkey, job = monkey_job
        if job.include?(" ")
            operations[monkey] = {
                op: job,
                dep: job.scan(/\w+/)
            }
        else
            numbers[monkey] = job.to_i
        end
    end

    numbers = solve(operations, numbers)
    p numbers['root']

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
    numbers
end

calculate data