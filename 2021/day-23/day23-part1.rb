require_relative './helper'
include Helper

AMPHIPOD_TYPE = {"A1" => "A", "A2" => "A", "B1" => "B", "B2" => "B", "C1" => "C", "C2" => "C", "D1" => "D", "D2" => "D"}
AMPHIPOD_HOMES = {"A" => ["R-A2", "R-A1"], "B" => ["R-B2", "R-B1"], "C" => ["R-C2", "R-C1"], "D" => ["R-D2", "R-D1"]}
ROOMS = ["R-A1", "R-A2", "R-B1", "R-B2", "R-C1", "R-C2", "R-D1", "R-D2"]
ROOM_TYPES = {"R-A1": "A", "R-A2": "A", "R-B1": "B", "R-B2": "B", "R-C1": "C", "R-C2": "C", "R-D1": "D", "R-D2": "D"}
OTHER_ROOM = {"R-A1" => "R-A2",  "R-B1" =>  "R-B2", "R-C1" => "R-C2", "R-D1" => "R-D2"}
HALLWAYS = ["h1", "h2", "h3", "h4", "h5", "h6", "h7"]
AMPHIPOD_ENERGY = {"A" => 1, "B" => 10, "C" => 100, "D" => 1000}
ENERGY_TAKEN = {
    "R-A1" => {"h1" => 3, "h2" => 2, "h3" => 2, "h4" => 4, "h5" => 6, "h6" => 8, "h7" => 9},
    "R-A2" => {"h1" => 4, "h2" => 3, "h3" => 3, "h4" => 5, "h5" => 7, "h6" => 9, "h7" => 10},
    "R-B1" => {"h1" => 5, "h2" => 4, "h3" => 2, "h4" => 2, "h5" => 4, "h6" => 6, "h7" => 7},
    "R-B2" => {"h1" => 6, "h2" => 5, "h3" => 3, "h4" => 3, "h5" => 5, "h6" => 7, "h7" => 8},
    "R-C1" => {"h1" => 7, "h2" => 6, "h3" => 4, "h4" => 2, "h5" => 2, "h6" => 4, "h7" => 5},
    "R-C2" => {"h1" => 8, "h2" => 7, "h3" => 5, "h4" => 3, "h5" => 3, "h6" => 5, "h7" => 6},
    "R-D1" => {"h1" => 9, "h2" => 8, "h3" => 6, "h4" => 4, "h5" => 2, "h6" => 2, "h7" => 3},
    "R-D2" => {"h1" => 10, "h2" => 9, "h3" => 7, "h4" => 5, "h5" => 3, "h6" => 3, "h7" => 4},
}

BLOCKING = {
    "R-A1" => {"h1" => ["h2"], "h2" => [], "h3" => [], "h4" => ["h3"], "h5" => ["h3", "h4"], "h6" => ["h3", "h4","h5"], "h7" => ["h3", "h4","h5","h6"]},
    "R-A2" => {"h1" => ["R-A1","h2"], "h2" => ["R-A1"], "h3" => ["R-A1"], "h4" => ["R-A1","h3"], "h5" => ["R-A1","h3", "h4"], "h6" => ["R-A1","h3", "h4","h5"], "h7" => ["R-A1","h3", "h4","h5","h6"]},
    "R-B1" => {"h1" => ["h2", "h3"], "h2" => ["h3"], "h3" => [], "h4" => [], "h5" => ["h4"], "h6" => ["h4", "h5"], "h7" => ["h4", "h5", "h6"]},
    "R-B2" => {"h1" => ["R-B1", "h2", "h3"], "h2" => ["R-B1", "h3"], "h3" => ["R-B1"], "h4" => ["R-B1"], "h5" => ["R-B1", "h4"], "h6" => ["R-B1", "h4", "h5"], "h7" => ["R-B1", "h4", "h5", "h6"]},
    "R-C1" => {"h1" => ["h2", "h3", "h4"], "h2" => [ "h3", "h4"], "h3" => ["h4"], "h4" => [], "h5" => [], "h6" => ["h5"], "h7" => ["h5", "h6"]},
    "R-C2" => {"h1" => ["R-C1","h2", "h3", "h4"], "h2" => [ "R-C1","h3", "h4"], "h3" => ["R-C1", "h4"], "h4" => ["R-C1"], "h5" => ["R-C1"], "h6" => ["R-C1","h5"], "h7" => ["R-C1","h5", "h6"]},
    "R-D1" => {"h1" => ["h2", "h3", "h4", "h5"], "h2" => [ "h3", "h4", "h5"], "h3" => ["h4", "h5"], "h4" => ["h5"], "h5" => [], "h6" => [], "h7" => ["h6"]},
    "R-D2" => {"h1" => ["R-D1", "h2", "h3", "h4", "h5"], "h2" => [ "R-D1", "h3", "h4", "h5"], "h3" => ["R-D1", "h4", "h5"], "h4" => ["R-D1", "h5"], "h5" => ["R-D1"], "h6" => ["R-D1"], "h7" => ["R-D1", "h6"]},
    "h1" => {"R-A1" => ["h2"], "R-A2" => ["h2", "R-A1"], "R-B1" => ["h2", "h3"], "R-B2" => ["h2", "h3", "R-B1"], "R-C1" => ["h2", "h3", "h4"], "R-C2" => ["h2", "h3", "h4", "R-C1"], "R-D1" => ["h2", "h3", "h4", "h5"], "R-D2" => ["h2", "h3", "h4", "h5", "R-D1"]},
    "h2" => {"R-A1" => [], "R-A2" => ["R-A1"], "R-B1" => ["h3"], "R-B2" => ["h3","R-B1"], "R-C1" => ["h3", "h4"], "R-C2" => ["h3", "h4","R-C1"], "R-D1" => ["h3", "h4", "h5"], "R-D2" => ["h3", "h4", "h5", "R-D1"]},
    "h3" => {"R-A1" => [], "R-A2" => ["R-A1"], "R-B1" => [], "R-B2" => ["R-B1"], "R-C1" => ["h4"], "R-C2" => ["h4", "R-C1"], "R-D1" => ["h4", "h5"], "R-D2" => ["h4", "h5", "R-D1"]},
    "h4" => {"R-A1" => ["h3"], "R-A2" => ["h3","R-A1"], "R-B1" => [], "R-B2" => ["R-B1"], "R-C1" => [], "R-C2" => ["R-C1"], "R-D1" => ["h5"], "R-D2" => ["h5","R-D1"]},
    "h5" => {"R-A1" => ["h3", "h4"], "R-A2" => ["h3", "h4", "R-A1"], "R-B1" => ["h4"], "R-B2" => ["h4","R-B1"], "R-C1" => [], "R-C2" => ["R-C1"], "R-D1" => [], "R-D2" => ["R-D1"]},
    "h6" => {"R-A1" => ["h3", "h4", "h5"], "R-A2" => ["h3", "h4", "h5", "R-A1"], "R-B1" => ["h4", "h5"], "R-B2" => ["h4", "h5", "R-B1"], "R-C1" => ["h5"], "R-C2" => ["h5","R-C1"], "R-D1" => [], "R-D2" => ["R-D1"]},
    "h7" => {"R-A1" => ["h3", "h4", "h5", "h6"], "R-A2" => ["h3", "h4", "h5", "h6", "R-A1"], "R-B1" => ["h4", "h5", "h6"], "R-B2" => ["h4", "h5", "h6", "R-B1"], "R-C1" => ["h5", "h6"], "R-C2" => ["h5", "h6","R-C1"], "R-D1" => [], "R-D2" => ["h6", "R-D1"]},
}

class Amphipod
    attr_accessor :move, :home
    attr_reader :id, :type, :energy
    def initialize id
        @id = id
        @type = AMPHIPOD_TYPE[id]
        @energy = AMPHIPOD_ENERGY[@type]
        @move = 0
        @home = false
    end
end

class Game
    attr_accessor :board, :energy

    def initialize board
        @energy = 0
        @board = board
    end

    def board_string
        board = ""
        @board.each {|space, val| board += "#{space}:#{val == "." ? val : val.type}_"}
        board
    end

    def update_who_is_home
        ["R-A2", "R-B2", "R-C2", "R-D2"].each do |room|
            if @board[room] != "." && @board[room].type == ROOM_TYPES[room]
                @board[room].home = true
            end
        end
        
        ["R-A1", "R-B1", "R-C1", "R-D1"].each do |room|
            if @board[room] != "." && @board[room].type == ROOM_TYPES[room] && @board[OTHER_ROOM[room]].type == ROOM_TYPES[room]
                @board[room].home = true
            end
        end
    end

    def count_amphipods
        count = 0
        @board.each { |room, space| count += 1 if space != "." }
        count
    end
end

def play

    min_energy = Float::INFINITY

    initial_board = {
        "R-A1" => Amphipod.new("C1"),
        "R-A2" => Amphipod.new("D1"),
        "R-B1" => Amphipod.new("C2"),
        "R-B2" => Amphipod.new("D2"),
        "R-C1" => Amphipod.new("A1"),
        "R-C2" => Amphipod.new("B1"),
        "R-D1" => Amphipod.new("B2"),
        "R-D2" => Amphipod.new("A2"),
        "h1" => ".", "h2" => ".", "h3" => ".", "h4" => ".", "h5" => ".", "h6" => ".", "h7" => "."
    }

    first_game = Game.new(initial_board)
    games = {first_game.board_string => first_game}

    16.times do |round|
        p "round: #{round}, games to play: #{games.length}"
        next_games = {}

        games.each do |key, game| 

            game.update_who_is_home()

            ROOMS.each do |room_move_1|
                HALLWAYS.each do |hallway_move_1|

                    #1. check if room can move to hallway
                    # does the room have an amphipod in it
                    # has the amphipod moved yet?
                    if game.board[room_move_1] != "." && game.board[hallway_move_1] == "." && !game.board[room_move_1].home
                    
                        # is the path to the hallway position blocked
                        unless move_blocked? room_move_1, hallway_move_1, game.board
                            amphipod = game.board[room_move_1]
            
                            new_amphipod = amphipod.clone
                            new_amphipod.move = 1

                            
                            new_game = clone_game game
                            new_game.board[room_move_1] = "."
                            new_game.board[hallway_move_1] = new_amphipod
                            new_game.energy += ENERGY_TAKEN[room_move_1][hallway_move_1] * new_amphipod.energy
                            
                            if new_game.count_amphipods != 8
                                p "going into hallway.."
                                p "amphipod: #{amphipod.id}"
                                p "BEFORE MOVE: original position: #{room_move_1} (#{game.board[room_move_1]})"
                                p "BEFORE MOVE: hallway position: #{hallway_move_1}, which is empty: #{game.board[hallway_move_1]}"
                                before_game_board = ""
                                game.board.each {|key, val| before_game_board += "#{key}: #{val == "." ? val : val.type}, " }
                                p "BEFORE MOVE: board: #{before_game_board}"
                                p "AFTER MOVE: original position: #{room_move_1} (#{new_game.board[room_move_1]})"
                                p "AFTER MOVE: hallway position: #{hallway_move_1} (#{new_game.board[hallway_move_1]})"
                                after_game_board = ""
                                new_game.board.each {|key, val| after_game_board += "#{key}: #{val == "." ? val : val.type}, " }
                                p "AFTER MOVE: board: #{after_game_board}"
                                p "AFTER MOVE count: #{new_game.count_amphipods}"
                                raise "Error: lost amphipod when moving to hallway"
                            end
                            
                            if next_games.key?(new_game.board_string)
                                if next_games[new_game.board_string].energy > new_game.energy
                                    next_games[new_game.board_string] = new_game
                                end
                            else
                                next_games[new_game.board_string] = new_game
                            end
                            # p new_game
                            # p "-----------"
                            # next_games.push(new_game)
                        end
                    end
                    
                    #2. check if hallway can move to it's room
                    if game.board[hallway_move_1] != "."
                        amphipod = game.board[hallway_move_1]
                        home_pos = AMPHIPOD_HOMES[amphipod.type][0]
                        # p game.board[home_pos].type
                        home_pos = AMPHIPOD_HOMES[amphipod.type][1] if game.board[home_pos] != "." && AMPHIPOD_HOMES[game.board[home_pos].type].include?(home_pos)
                        
                        # p "move blocked?: #{move_blocked?(hallway_move_1, home_pos, game.board)}"
                        
                        unless game.board[home_pos] != "." || move_blocked?(hallway_move_1, home_pos, game.board)        
                            # p "going home.."
                            # p "amphipod: #{amphipod.id}"
                            # p "hallway position: #{hallway_move_1}"
                            # p "home position: #{home_pos}, which is empty: #{game.board[home_pos]}"
                            new_amphipod = amphipod.clone
                            new_amphipod.move = 2
            
                            new_game = clone_game game
                            new_game.board[hallway_move_1] = "."
                            new_game.board[home_pos] = new_amphipod
                            new_game.energy += ENERGY_TAKEN[home_pos][hallway_move_1] * new_amphipod.energy
            
                            # p new_game
                            # p "-----------"
                            # p "moved #{new_amphipod.id} home to #{home_pos}"

                            if new_game.count_amphipods != 8
                                p "amphipod: #{amphipod.id}"
                                p "BEFORE MOVE: original position: #{hallway_move_1} (#{game.board[room_move_1]})"
                                p "BEFORE MOVE: home position: #{home_pos}, which is empty: #{game.board[home_pos]}"
                                before_game_board = ""
                                game.board.each {|key, val| before_game_board += "#{key}: #{val == "." ? val : val.type}, " }
                                p "BEFORE MOVE: board: #{before_game_board}"
                                p "AFTER MOVE: original position: #{hallway_move_1} (#{new_game.board[hallway_move_1]})"
                                p "AFTER MOVE: home position: #{home_pos} (#{new_game.board[home_pos]})"
                                after_game_board = ""
                                new_game.board.each {|key, val| after_game_board += "#{key}: #{val == "." ? val : val.type}, " }
                                p "AFTER MOVE: board: #{after_game_board}"
                                p "AFTER MOVE count: #{new_game.count_amphipods}"
                                raise "Error: lost amphipod when moving to home position"
                            end

                            if next_games.key?(new_game.board_string)
                                if next_games[new_game.board_string].energy > new_game.energy
                                    next_games[new_game.board_string] = new_game
                                end
                            else
                                next_games[new_game.board_string] = new_game
                            end
                        end
                    end

                    # check if 
                end
            end

        end
        # check here if any of the next games are winning games. If so, remove from array and update min_energy if appropriate
        the_next_games = {}
        next_games.each do |key, game|
            if winning? game
                min_energy = [game.energy, min_energy].min
                p min_energy
            else
                the_next_games[key] = game
            end
        end

        break if the_next_games.count === 0
        # p "current games:"
        # games.each do |game| 
        #     game_board = ""
        #     game.board.each {|key, val| game_board += "#{key}: #{val == "." ? val : val.type}, " }
        #     p game_board
        # end
        # p "next games:"
        # the_next_games.each do |game| 
        #     game_board = ""
        #     game.board.each {|key, val| game_board += "#{key}: #{val == "." ? val : val.type}, " }
        #     p game_board
        # end
        # game_board = "" 
        # games.last.board.each {|key, val| game_board += "#{key}: #{val == "." ? val : val.type}, " }
        # p game_board

        games = Helper::deep_copy(the_next_games)
       
    end
    p min_energy
end


def move_blocked? start_pos, end_pos, board

    is_blocked = false
    BLOCKING[start_pos][end_pos].each do |position|
        # if (room.key?(position))
            is_blocked = true unless board[position] == "."
            break unless board[position] == "."
        # else
        #     is_blocked = true unless hallway[position] == "."
        #     break unless hallway[position] == "."
        # end
    end

    is_blocked

end

def clone_game game
    cloned_board = {}
    ROOMS.each {|room| cloned_board[room] = game.board[room].clone }
    HALLWAYS.each {|hallway| cloned_board[hallway] = game.board[hallway].clone }
    cloned_game = Game.new(cloned_board)
    cloned_game.energy = game.energy
    cloned_game
end

def winning? game
    has_won = true
    ROOMS.each do |room|
        has_won = false if game.board[room] == "."
        break unless has_won
        has_won = false unless AMPHIPOD_HOMES[game.board[room].type].include? room
        break unless has_won
    end

    has_won
end

play()