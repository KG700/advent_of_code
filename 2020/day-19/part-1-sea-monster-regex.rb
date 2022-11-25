require_relative '../helper'
include Helper

code_data = File.read("2020/day-19/code-data.txt")
test_1_data = File.read("2020/day-19/part-1-test-1-data.txt")
test_2_data = File.read("2020/day-19/part-1-test-2-data.txt")

def sea_monster data
    input_rules = {}
    regex_rules = {}
    rules, letters = data.split(/\n\n/)
    rules = rules.split(/\n/)
    letters = letters.split(/\n/)

    rule_a = rules.select { |rule| rule.include?("a") }
    rule_b = rules.select { |rule| rule.include?("b") }

    regex_rules[rule_a[0].split(":")[0]] = "a"
    regex_rules[rule_b[0].split(":")[0]] = "b"

    rules.each do |rule|
        next if rule.include?("a") || rule.include?("b")
        rule_key, input_rule = rule.split(": ")
        input_rules[rule_key] = {
            str: input_rule,
            dep: input_rule.scan(/\d+/).uniq
        }
    end

    loop do
        rules_to_regexify = input_rules.select { |id, rule| (rule[:dep] - regex_rules.keys).empty? }
        rules_to_regexify.each do |id, rule|
            regex_string = "("
            rule_combinations = rule[:str].split(" | ").map(&:split)
            regex_strings = rule_combinations.map do |rule|
                regex_rule = rule.map {|num| regex_rules[num] }.join("")
            end
            regex_rules[id] = "(#{regex_strings.join("|")})"
            input_rules.delete(id)
        end
        break if input_rules.empty?
    end

    rule_0 = /\A#{regex_rules["0"]}\z/
    valid_letters = letters.count do |letter|
        !!letter.match(rule_0)
    end
    p valid_letters

end

sea_monster(code_data)