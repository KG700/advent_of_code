require_relative '../helper'
include Helper

code_data = Helper::upload("day-10/part-1-input.txt")
code_test_data = Helper::upload("day-10/test-input.txt")

SYNTAX_SCORES = { "(" => 1, "[" => 2, "{" => 3, "<" => 4, nil => 0 }

def sytax_scrore code_data
    
    incomplete_lines = []
    illegal_character = nil
    score = 0
    code_data.each do |line|
        open_code = []
        line.split("").each do |code|
            if ["(", "[", "{", "<"].include? code
                open_code.push(code)
            else
                case code
                when ")"
                    if open_code[-1] === "("
                        open_code.pop 
                    else
                        illegal_character = code
                        break
                    end
                when "]"
                    if open_code[-1] === "["
                        open_code.pop 
                    else
                        illegal_character = code
                        break
                    end
                when "}"
                    if open_code[-1] === "{"
                        open_code.pop 
                    else
                        illegal_character = code
                        break
                    end
                when ">"
                    if open_code[-1] === "<"
                        open_code.pop 
                    else
                        illegal_character = code
                        break
                    end
                end

            end
        end
        # score += SYNTAX_SCORES[illegal_character]
        incomplete_lines.push(open_code.reverse) if illegal_character.nil?
        illegal_character = nil
    end
    line_scores = incomplete_lines.map do |line|
        line.reduce(0) do |sum, char|
            (sum * 5) + SYNTAX_SCORES[char]
        end
    end
    p line_scores.sort[line_scores.length/2]
end

sytax_scrore code_data