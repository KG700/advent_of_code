require 'set'

code_data = File.read("2021/day-13/part-1-input.txt")
code_data_test = File.read("2021/day-13/test-input.txt")

def origami data

    paper, instructions = data.split(/\n\n/).map {|x| x.split(/\n/)}
    instructions = instructions.map {|instruction| instruction.gsub("fold along ", "").split("=") }

    folded_paper = Set[]
    paper.each do |dot|
        dot_arr = dot.split(",").map(&:to_i)
        is_x_fold = instructions[0][0] === "x"
        if is_x_fold && dot_arr[0] < instructions[0][1].to_i
            folded_paper.add(dot)
        elsif !is_x_fold && dot_arr[1] < instructions[0][1].to_i
            folded_paper.add(dot)
        else
            x_axis = is_x_fold ? instructions[0][1].to_i - (dot_arr[0] - instructions[0][1].to_i) : dot_arr[0]
            y_axis = !is_x_fold ? instructions[0][1].to_i - (dot_arr[1] - instructions[0][1].to_i) : dot_arr[1]
            folded_paper.add("#{x_axis},#{y_axis}")
        end
    end
    p folded_paper.length
end

origami code_data