require 'set'
require_relative '../helper'
include Helper

data = Helper::upload_line_break("2022/day-11/input.txt")
data_test = Helper::upload_line_break("2022/day-11/input-test.txt")

class Item
    @@tests = Set.new()

    attr_reader :values

    def initialize test, initial_value
        @@tests.add(test)
        @initial_value = initial_value
        @values = {}
    end

    def self.tests
        @@tests
    end

    def initialise_test_values
        @@tests.each { |test| @values[test] = @initial_value }
    end

    def do_tests test, operation
        operation = operation.split(" ")
        @values.each do |test, value|
            case operation[0]
                when '*'
                    operation_value = operation[1] == 'old' ? value : operation[1].to_i
                    @values[test] = (value * operation_value) % test
                when '+'
                    @values[test] = (value + operation[1].to_i) % test
                else
                    p operation[0]
                    throw "Error: Don't recogise operation"
            end
        end
    end
end

class Monkey

    attr_accessor :items, :item_count
    attr_reader :divisible_test, :operation, :monkey_to_throw_to

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

end

def calculate monkeys
    monkeys = monkeys.map do |monkey| 
        info = monkey.split("\n ")
        operation = info[2].gsub(' Operation: new = old ', '')
        divisible_test = info[3].split(" ").last.to_i
        items = info[1].gsub(' Starting items: ', '').split(", ").map {|value| Item.new(divisible_test, value.to_i) }
        monkey_to_throw_to = {true => info[4].split(" ").last.to_i, false => info[5].split(" ").last.to_i}
        new_monkey = Monkey.new(items, operation, divisible_test, monkey_to_throw_to)
    end
    
    monkeys.each { |monkey| monkey.items.each { |item| item.initialise_test_values } }

    10000.times do |round|

        monkeys.each do |monkey|
            (monkey.items.length).times do |i|
                monkey.item_count += 1
                item = monkey.items.shift
                item.do_tests(monkey.divisible_test, monkey.operation)

                is_divisible = item.values[monkey.divisible_test] == 0
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

calculate data