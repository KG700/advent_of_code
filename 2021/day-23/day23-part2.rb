require_relative '../helper'
include Helper

ROOMS = ["R-A1", "R-A2", "R-A3", "R-A4", "R-B1", "R-B2", "R-B3", "R-B4", "R-C1", "R-C2", "R-C3", "R-C4", "R-D1", "R-D2", "R-D3", "R-D4"]
HALLWAYS = ["h1", "h2", "h3", "h4", "h5", "h6", "h7"]
    
    class Amphipod
        
        AMPHIPOD_ENERGY = {"A" => 1, "B" => 10, "C" => 100, "D" => 1000}
        AMPHIPOD_HOMES = {"A" => ["R-A4", "R-A3", "R-A2", "R-A1"], "B" => ["R-B4", "R-B3", "R-B2", "R-B1"], "C" => ["R-C4", "R-C3", "R-C2", "R-C1"], "D" => ["R-D4", "R-D3", "R-D2", "R-D1"]}
        
        attr_accessor :home
        attr_reader :type, :energy, :homes
        
        def initialize type
            @type = type
            @energy = AMPHIPOD_ENERGY[type]
            @homes =  AMPHIPOD_HOMES[type]
            @home = false
        end
    end
    
    class Game
        
    OTHER_ROOMS = {"R-A1" => ["R-A2", "R-A3", "R-A4"], "R-A2" => ["R-A3", "R-A4"], "R-A3" => ["R-A4"], "R-B1" => ["R-B2", "R-B3", "R-B4"], "R-B2" => ["R-B3", "R-B4"], "R-B3" => ["R-B4"], "R-C1" => ["R-C2", "R-C3", "R-C4"], "R-C2" => ["R-C3", "R-C4"], "R-C3" => ["R-C4"], "R-D1" => ["R-D2", "R-D3", "R-D4"], "R-D2" => ["R-D3", "R-D4"], "R-D3" => ["R-D4"]}
    LAST_ROOMS = ["R-A4", "R-B4", "R-C4", "R-D4"]
    STEPS = {
    "R-A" => {"h1" => 3, "h2" => 2, "h3" => 2, "h4" => 4, "h5" => 6, "h6" => 8, "h7" => 9},
    "R-B" => {"h1" => 5, "h2" => 4, "h3" => 2, "h4" => 2, "h5" => 4, "h6" => 6, "h7" => 7},
    "R-C" => {"h1" => 7, "h2" => 6, "h3" => 4, "h4" => 2, "h5" => 2, "h6" => 4, "h7" => 5},
    "R-D" => {"h1" => 9, "h2" => 8, "h3" => 6, "h4" => 4, "h5" => 2, "h6" => 2, "h7" => 3},
    }
    BLOCKING = {
        "R-A" => {"h1" => ["h2"], "h2" => [], "h3" => [], "h4" => ["h3"], "h5" => ["h3", "h4"], "h6" => ["h3", "h4","h5"], "h7" => ["h3", "h4","h5","h6"]},
        "R-B" => {"h1" => ["h2", "h3"], "h2" => ["h3"], "h3" => [], "h4" => [], "h5" => ["h4"], "h6" => ["h4", "h5"], "h7" => ["h4", "h5", "h6"]},
        "R-C" => {"h1" => ["h2", "h3", "h4"], "h2" => [ "h3", "h4"], "h3" => ["h4"], "h4" => [], "h5" => [], "h6" => ["h5"], "h7" => ["h5", "h6"]},
        "R-D" => {"h1" => ["h2", "h3", "h4", "h5"], "h2" => [ "h3", "h4", "h5"], "h3" => ["h4", "h5"], "h4" => ["h5"], "h5" => [], "h6" => [], "h7" => ["h6"]},
    }

    attr_accessor :board, :energy
    
    def initialize board
        @energy = 0
        @board = board
    end
    
    def board_key
        board = ""
        @board.each {|space, val| board += "#{space}:#{val == "." ? val : val.type}_"}
        board
    end
    
    def update_who_is_home
        ROOMS.each do |room|
            if @board[room] != "." && @board[room].type == room[2]
                if LAST_ROOMS.include?(room)
                    @board[room].home = true
                else
                    OTHER_ROOMS[room].each do |other_room|
                        @board[room].home = true if @board[other_room] != "." && @board[other_room].type == room[2]
                    end
                end
            end
        end
    end

    def count_amphipods
        count = 0
        @board.each { |room, space| count += 1 if space != "." }
        count
    end

    def create_new_game start_pos, new_pos
        raise "Error: start position is not an amphipod when creating new game" if @board[start_pos] == "."
        raise "Error: new position is not an empty space when creating new game" if @board[new_pos] != "."

        new_amphipod = @board[start_pos].clone

        new_game = clone_game
        new_game.board[start_pos] = "."
        new_game.board[new_pos] = new_amphipod
        steps_taken = ROOMS.include?(start_pos) ? get_steps(start_pos, new_pos) : get_steps(new_pos, start_pos)
        new_game.energy += steps_taken * new_amphipod.energy
        new_game

    end

    def move_blocked? start_pos, end_pos
        room = ROOMS.include?(start_pos) ? start_pos : end_pos
        hallway = HALLWAYS.include?(start_pos) ? start_pos : end_pos

        is_blocked = false
        BLOCKING[room[0,3]][hallway].each do |position|
            is_blocked = @board[position] != "."
            break if is_blocked
        end

        if room[-1].to_i > 1 && !is_blocked
            (room[-1].to_i - 1).times do |room_pos|
                is_blocked = @board["#{room[0,3]}#{room_pos + 1}"] != "."
                break if is_blocked
            end
        end

        is_blocked
    end

    def winning?
        has_won = true
        ROOMS.each do |room|
            has_won = false if @board[room] == "."
            break unless has_won
            has_won = false unless @board[room].homes.include? room
            break unless has_won
        end

        has_won
    end

    def clone_game
        cloned_board = {}
        ROOMS.each {|room| cloned_board[room] = @board[room].clone }
        HALLWAYS.each {|hallway| cloned_board[hallway] = @board[hallway].clone }
        cloned_game = self.class.new(cloned_board)
        cloned_game.energy = @energy
        cloned_game
    end

    def get_steps room, hallway
        total_steps = STEPS[room[0,3]][hallway]
        total_steps += room[-1].to_i - 1
        total_steps
    end
end


def play

    min_energy = Float::INFINITY

    initial_board = {
        "R-A1" => Amphipod.new("C"),
        "R-A2" => Amphipod.new("D"),
        "R-A3" => Amphipod.new("D"),
        "R-A4" => Amphipod.new("D"),
        "R-B1" => Amphipod.new("C"),
        "R-B2" => Amphipod.new("C"),
        "R-B3" => Amphipod.new("B"),
        "R-B4" => Amphipod.new("D"),
        "R-C1" => Amphipod.new("A"),
        "R-C2" => Amphipod.new("B"),
        "R-C3" => Amphipod.new("A"),
        "R-C4" => Amphipod.new("B"),
        "R-D1" => Amphipod.new("B"),
        "R-D2" => Amphipod.new("A"),
        "R-D3" => Amphipod.new("C"),
        "R-D4" => Amphipod.new("A"),
        "h1" => ".", "h2" => ".", "h3" => ".", "h4" => ".", "h5" => ".", "h6" => ".", "h7" => "."
    }

    first_game = Game.new(initial_board)
    games = {first_game.board_key => first_game}

    (first_game.count_amphipods*2).times do |round|
    # 2.times do |round|
        p "round: #{round}, games to play: #{games.length}"
        next_games = {}

        games.each do |key, game| 

            game.update_who_is_home()

            ROOMS.each do |room|
                HALLWAYS.each do |hallway|

                    if game.board[room] != "." && !game.board[room].home && game.board[hallway] == "."
                    
                        unless game.move_blocked? room, hallway
                            new_game = game.create_new_game(room, hallway)
                            
                            raise "Error: lost amphipod when moving to hallway" if new_game.count_amphipods != 16

                            is_duplicated_game = next_games.key?(new_game.board_key) && next_games[new_game.board_key].energy <= new_game.energy
                            next_games[new_game.board_key] = new_game unless is_duplicated_game
                            
                        end
                    end
                    
                    if game.board[hallway] != "."
                
                        amphipod = game.board[hallway]
                        home_pos = ""
                        amphipod.homes.each do |home|
                            if game.board[home] == "." || !game.board[home].homes.include?(home)
                                home_pos = home
                                break
                            end
                        end
                        
                        unless game.board[home_pos] != "." || game.move_blocked?(hallway, home_pos) 
                            new_game = game.create_new_game(hallway, home_pos)       
                    
                            raise "Error: lost amphipod when moving to home position" if new_game.count_amphipods != 16
                            is_duplicated_game = next_games.key?(new_game.board_key) && next_games[new_game.board_key].energy <= new_game.energy
                            next_games[new_game.board_key] = new_game unless is_duplicated_game
                        end
                    end
                end
            end

        end

        the_next_games = {}
        next_games.each do |key, game|
            if game.winning?
                min_energy = [game.energy, min_energy].min
                p min_energy
            else
                the_next_games[key] = game
            end
        end

        break if the_next_games.count === 0

        games = Helper::deep_copy(the_next_games)
       
    end
    p min_energy
end

play()