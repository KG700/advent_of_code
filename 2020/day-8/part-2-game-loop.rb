require "set"
require_relative '../helper'
include Helper

def first_loop_accumulator
    commands_data = Helper::upload("day-8/game-commands-data.txt")
    commands = commands_data.map { |command| command.split(" ")}
    commands_clone = commands[0..-1]
    
    commands_clone.each_with_index do |command, index|
        actioned_commands = Set.new()
        n = 0
        accumulator = 0
        terminated = false
        original_command = command
        
        if command[0] == "nop"
            commands[index][0] = "jmp"
        elsif command[0] == "jmp"
            commands[index][0] = "nop"
        end

        loop do
            break if actioned_commands.include?(n)
            if n >= commands.length
                terminated = true
                break
            end
            
            actioned_commands.add(n)
            case commands[n][0]
            when "acc"
                accumulator += commands[n][1].to_i
                n += 1
            when "jmp"
                n += commands[n][1].to_i
            when "nop"
                n += 1
            end
        end

        if command[0] == "nop"
            commands[index][0] = "jmp"
        elsif command[0] == "jmp"
            commands[index][0] = "nop"
        end
        # p commands[index]
        if terminated
            p accumulator
            break
        end

    end
end

first_loop_accumulator