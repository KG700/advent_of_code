require_relative '../helper'
include Helper

homework_data = Helper::upload("day-18/homework-data.txt")
test_data = Helper::upload("day-18/test-data.txt")

def do_homework exercises
    answers = []
    exercises.each do |exercise|
        answers.push(solve(exercise.split(" ")))
    end
    p "answers:"
    # p answers
    p answers.inject(:+)
end

def split_by_brackets equation
    # p equation
    open_brackets = 0
    main_equation = []
    sub_equation = []
    equation.each do |eq|
        if eq.include?("(")
            if open_brackets == 0
                eq[0] = ''
                open_brackets += 1
            end
            open_brackets += eq.count("(")
            sub_equation.push(eq)
        elsif eq.include?(")")
            open_brackets -= eq.count(")")
            eq[-1] = '' if open_brackets == 0
            sub_equation.push(eq)
            main_equation.push(sub_equation) if open_brackets == 0
            sub_equation = [] if open_brackets == 0
        elsif open_brackets > 0
            sub_equation.push(eq)
        else
            main_equation.push(eq)
        end
    end
    main_equation
    # p main_equation
end

def split_by_plus_sign equation
    # p equation
    main_equation = []
    sub_equation = []
    plus_signs = 0
    equation.each_with_index do |eq, index|
        if index.odd?
            if eq == '+'
                plus_signs += 1
                sub_equation.push(equation[index - 1])
                sub_equation.push(equation[index])
            else
                if sub_equation.empty?
                    main_equation.push(equation[index - 1])
                else
                    sub_equation.push(equation[index - 1])
                    main_equation.push(sub_equation)
                    sub_equation = []
                end
                main_equation.push(equation[index])

            end
            
        end
    end
    if !sub_equation.empty?
        sub_equation.push(equation[-1])
        main_equation.push(sub_equation)
    else
        main_equation.push(equation[-1])
    end

    if main_equation[0] == equation
        return main_equation[0]
    else
        return main_equation
    end
end

def solve equation
    current_operation = 'PLUS'
    current_value = 0
    # 1. split into subequations
    # p "split by brackets"
    subequations = split_by_brackets(equation)
    # p subequations
    subequations = split_by_plus_sign(subequations)
    # p "split by plus sign"
    # p subequations
    # 2. loop through equation:
    # p subequations
    subequations.each do |eq|
        if eq.is_a?(Array)
            # p "is array"
            value = solve(eq)
            current_value = update_current_value(current_value, value, current_operation)
            next
        end
            
        current_operation = 'PLUS' if eq == '+'
        current_operation = 'MINUS' if eq == '-'
        current_operation = 'MULTIPLY' if eq == '*'

        if eq.is_i?
            # p "is integer"
            current_value = update_current_value(current_value, eq, current_operation)
        end
    end
    return current_value
end

def update_current_value current_value, new_value, operation
    case operation
    when 'PLUS'
        current_value += new_value.to_i
    when 'MINUS'
        current_value -= new_value.to_i
    when 'MULTIPLY'
        current_value *= new_value.to_i
    end
    return current_value
end

class String
    def is_i?
       /\A[-+]?\d+\z/ === self
    end
end

do_homework(homework_data)


