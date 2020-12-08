require "set"

def first_loop_accumulator
    commands_data = upload("day-8/game-commands-data.txt")
    commands = commands_data.map { |command| command.split(" ")}
    commands_clone = commands[0..-1]
    # p commands.length
    
    commands_clone.each_with_index do |command, index|
        p command
        actioned_commands = Set.new()
        n = 0
        accumulator = 0
        terminated = false
        original_command = command
        # p original_command
        
        if command[0] == "nop"
            commands[index][0] = "jmp"
        elsif command[0] == "jmp"
            commands[index][0] = "nop"
        end
        p commands[index]

        loop do
            break if actioned_commands.include?(n)
            # p "n:"
            # p n
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

        # commands[index][0] = original_command[0]
        if command[0] == "nop"
            commands[index][0] = "jmp"
        elsif command[0] == "jmp"
            commands[index][0] = "nop"
        end
        # p original_command
        p commands[index]
        # p "accumulator:"
        # p accumulator
        # p "n:"
        # p n
        if terminated
            p accumulator
            break
        end

    end
end

def upload file
    file = File.open(file)
    file_data = file.readlines.map(&:chomp)
    file.close
    file_data
end

first_loop_accumulator