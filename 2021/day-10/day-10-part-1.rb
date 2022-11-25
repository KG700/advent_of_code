require_relative '../helper'
include Helper

code_data = Helper::upload("2021/day-10/part-1-input.txt")
code_test_data = Helper::upload("2021/day-10/test-input.txt")

SYNTAX_SCORES = { ")" => 3, "]" => 57, "}" => 1197, ">" => 25137, nil => 0 }

def sytax_scrore code_data
    
    open_code = []
    illegal_character = nil
    score = 0
    code_data.each do |line|
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
        score += SYNTAX_SCORES[illegal_character]
        illegal_character = nil
    end
    p score
end

sytax_scrore code_data