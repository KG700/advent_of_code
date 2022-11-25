require 'set'

code_data = File.read("day-13/part-1-input.txt")
code_data_test = File.read("day-13/test-input.txt")

def origami data

    paper, instructions = data.split(/\n\n/).map {|x| x.split(/\n/)}
    instructions = instructions.map {|instruction| instruction.gsub("fold along ", "").split("=") }
    p paper.length
    # folded_paper = Set[]
    instructions.each do |instruction|
        p instruction
        folded_paper = Set[]
        paper.each do |dot|
            # p dot
            dot_arr = dot.split(",").map(&:to_i)
            # p dot_arr
            is_x_fold = instruction[0] === "x"
            if is_x_fold && dot_arr[0] < instruction[1].to_i
                folded_paper.add(dot)
            elsif !is_x_fold && dot_arr[1] < instruction[1].to_i
                folded_paper.add(dot)
            else
                x_axis = is_x_fold ? instruction[1].to_i - (dot_arr[0] - instruction[1].to_i) : dot_arr[0]
                y_axis = !is_x_fold ? instruction[1].to_i - (dot_arr[1] - instruction[1].to_i) : dot_arr[1]
                folded_paper.add("#{x_axis},#{y_axis}")
            end
        end
        paper = folded_paper.to_a
        # p papers
    end
    
    pattern = Array.new(6) {|dot| " "*40}
    
    paper.each do |dot| 
        dot_arr = dot.split(",").map(&:to_i)
        pattern[dot_arr[1]][dot_arr[0]] = "x"

    end
    pattern.each {|row| p row}
end

origami code_data