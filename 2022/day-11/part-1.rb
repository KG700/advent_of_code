require_relative '../helper'
include Helper

data = Helper::upload_line_break("2022/day-11/input.txt")
data_test = Helper::upload_line_break("2022/day-11/input-test.txt")

class Monkey

    attr_accessor :items, :item_count
    attr_reader :operation, :divisible_test, :monkey_to_throw_to

    def initialize items, operation, divisible_test, monkey_to_throw_to
        @items = items
        @operation = operation
        @divisible_test = divisible_test
        @monkey_to_throw_to = monkey_to_throw_to
        @item_count = 0
    end

    def throw_to monkey, item
        monkey.items.push(item)
    end

    def do_operation item
        case @operation[0]
            when '*'
                item *= @operation[1] == 'old' ? item : @operation[1].to_i
            when '+'
                item += @operation[1].to_i
            else
                throw "Error: Don't recogise operation"
        end
        item
    end
end

def calculate monkeys
    monkeys = monkeys.map do |monkey| 
        info = monkey.split("\n ")
        items = info[1].gsub(' Starting items: ', '').split(", ").map(&:to_i)
        operation = info[2].gsub('Operation: new = old ', '').split(" ")
        divisible_test = info[3].split(" ").last.to_i
        monkey_to_throw_to = {true => info[4].split(" ").last.to_i, false => info[5].split(" ").last.to_i}
        new_monkey = Monkey.new(items, operation, divisible_test, monkey_to_throw_to)
    end

    20.times do |round|

        monkeys.each do |monkey|
            (monkey.items.length).times do |i|
                monkey.item_count += 1
                item = monkey.items.shift
                item = monkey.do_operation item
                is_divisible = item % monkey.divisible_test == 0
                monkey_to_throw_to = monkeys[monkey.monkey_to_throw_to[is_divisible]]
                monkey.throw_to(monkey_to_throw_to, item)
            end
        end
    end

    handled_items = []
    monkeys.map { |monkey| handled_items.push(monkey.item_count) }
    p handled_items.sort.reverse[0..1].inject(:*)
    p handled_items
end

calculate data_test