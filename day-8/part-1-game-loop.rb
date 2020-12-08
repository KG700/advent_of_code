require "set"

def first_loop_accumulator
    commands_data = upload("day-8/game-commands-data.txt")
    commands = commands_data.map { |command| command.split(" ")}
    # p commands

    actioned_commands = Set.new()
    index = 0
    accumulator = 0
    while !actioned_commands.include?(index)
        actioned_commands.add(index)
        case commands[index][0]
        when "acc"
            accumulator += commands[index][1].to_i
            index += 1
        when "jmp"
            index += commands[index][1].to_i
        when "nop"
            index += 1
        end
    end
    p accumulator
end

def upload file
    file = File.open(file)
    file_data = file.readlines.map(&:chomp)
    file.close
    file_data
end

first_loop_accumulator