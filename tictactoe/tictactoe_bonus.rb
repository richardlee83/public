# tictactoe_bonus.rb
require "io/console"
require "yaml"

# constants
MESSAGES = YAML.load_file("tictactoe_bonus.yml")
INITIAL_MARKER = " "
PLAYER_MARKER = "X"
COMPUTER_MARKER = "O"
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                [[1, 5, 9], [3, 5, 7]]              # diagonals

# methods
def prompt(msg)
  print "=> #{msg}"
end

def messages(msg)
  MESSAGES[msg]
end

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def clear_screen
  system "clear"
end

def display_score(player_score=0, computer_score=0)
  puts "Score: Player: #{player_score}, Computer: #{computer_score}"
end

def display_spacer
  puts ""
end

# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/MethodLength
def display_board(brd, plyr_scr, cmptr_scr)
  clear_screen
  display_spacer
  puts "              TIC TAC TOE"
  puts "        ======================="
  display_spacer
  puts "        1      |2      |3      "
  puts "           #{brd[1]}   |   #{brd[2]}   |   #{brd[3]}   "
  puts "               |       |       "
  puts "        -------+-------+-------      Player = X"
  puts "        4      |5      |6      "
  puts "           #{brd[4]}   |   #{brd[5]}   |   #{brd[6]}   "
  puts "               |       |       "
  puts "        -------+-------+-------     Computer = O"
  puts "        7      |8      |9      "
  puts "           #{brd[7]}   |   #{brd[8]}   |   #{brd[9]}   "
  puts "               |       |       "
  puts ""
  print "     "
  display_score(plyr_scr, cmptr_scr)
  display_spacer
end
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/MethodLength

def greeting_msg
  system "clear"
  prompt messages("welcome")
  prompt messages("start_playing")
  STDIN.getch
  display_spacer
  display_spacer
end

# rubocop:disable Metrics/MethodLength
def difficulty_selection
  difficulty = nil
  loop do
    prompt messages("difficulty_levels")
    display_spacer
    prompt messages("difficulty_selection")
    difficulty_choice = gets.chomp
    if difficulty_choice == "1"
      difficulty = "Easy"
      break
    elsif difficulty_choice == "2"
      difficulty = "Medium"
      break
    elsif difficulty_choice == "3"
      difficulty = "Hard"
      break
    elsif difficulty_choice == "4"
      difficulty = "Super Hard"
      break
    end
    display_spacer
    prompt messages("invalid_choice")
    display_spacer
  end
  difficulty
end
# rubocop:enable Metrics/MethodLength

def display_selection(difficulty)
  display_spacer
  print "=> You have chosen: #{difficulty}. Press any key to continue."
  STDIN.getch
  display_spacer
  display_spacer
end

def first_player_selection
  choice = nil
  loop do
    prompt messages("go_first")
    choice = gets.chomp.downcase
    break if choice.start_with?("y") || choice.start_with?("n")
    display_spacer
    prompt messages("invalid_choice")
    display_spacer
  end
  choice.start_with?("y") ? "Player" : "Computer"
end

def display_first_player(plyr)
  display_spacer
  if plyr == "Player"
    prompt messages("player_go_first")
  else
    prompt messages("computer_go_first")
  end
  STDIN.getch
end

def empty_squares(brd)
  brd.keys.select { |position| brd[position] == INITIAL_MARKER }
end

def joinor(arr, delimiter=", ", word="or")
  joinor_arr = []
  start_index = 0
  end_index = arr.size - 1
  loop do
    curr_val = arr[start_index]
    joinor_arr << curr_val
    delimiter = " " if arr.size == 2 && start_index == 0
    joinor_arr << delimiter if start_index != end_index
    joinor_arr << word + " " if start_index == end_index - 1
    start_index += 1
    break if start_index > end_index
  end
  joinor_arr.join
end

def player_marks!(brd)
  position = nil
  loop do
    prompt messages("choose_square") + "#{joinor(empty_squares(brd))}: "
    position = gets.chomp.to_i
    break if empty_squares(brd).include?(position)
    display_spacer
    prompt messages("invalid_choice")
    display_spacer
  end
  brd[position] = PLAYER_MARKER
end

# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/PerceivedComplexity
# rubocop:disable Metrics/CyclomaticComplexity
def winning_square(brd, line)
  square = nil
  if brd[line[0]] == COMPUTER_MARKER &&
     brd[line[1]] == COMPUTER_MARKER &&
     brd[line[2]] == INITIAL_MARKER
    return line[2]
  elsif brd[line[0]] == INITIAL_MARKER &&
        brd[line[1]] == COMPUTER_MARKER &&
        brd[line[2]] == COMPUTER_MARKER
    return line[0]
  elsif brd[line[0]] == COMPUTER_MARKER &&
        brd[line[1]] == INITIAL_MARKER &&
        brd[line[2]] == COMPUTER_MARKER
    return line[1]
  end
  square
end
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/PerceivedComplexity
# rubocop:enable Metrics/CyclomaticComplexity

def winning_position?(brd, line)
  winning_square(brd, line)
end

# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/PerceivedComplexity
# rubocop:disable Metrics/CyclomaticComplexity
def defensive_square(brd, line)
  position = nil
  if brd[line[0]] == PLAYER_MARKER &&
     brd[line[1]] == PLAYER_MARKER &&
     brd[line[2]] == INITIAL_MARKER
    return line[2]
  elsif brd[line[0]] == INITIAL_MARKER &&
        brd[line[1]] == PLAYER_MARKER &&
        brd[line[2]] == PLAYER_MARKER
    return line[0]
  elsif brd[line[0]] == PLAYER_MARKER &&
        brd[line[1]] == INITIAL_MARKER &&
        brd[line[2]] == PLAYER_MARKER
    return line[1]
  end
  position
end
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/PerceivedComplexity
# rubocop:enable Metrics/CyclomaticComplexity

def blocking_position?(brd, line)
  defensive_square(brd, line)
end

def assigned?(position)
  position
end

def winning(brd, position)
  # if there is a winning move, take it
  WINNING_LINES.each do |line|
    if winning_position?(brd, line)
      position = winning_square(brd, line)
      break if assigned?(position)
    end
  end
  position
end

def blocking(brd, position)
  # if player is one move away from winning, block it
  WINNING_LINES.each do |line|
    if blocking_position?(brd, line)
      position = defensive_square(brd, line)
      break if assigned?(position)
    end
  end
  position
end

# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/CyclomaticComplexity
def center(brd, position)
  # if center square is free, take it
  center_square = brd[5]
  if !assigned?(position)
    if center_square == INITIAL_MARKER
      position = 5
    end
  end
  # if center square is taken by player, take a corner
  corner_squares = [1, 3, 7, 9]
  available_squares = empty_squares(brd)
  if !assigned?(position)
    if center_square == PLAYER_MARKER
      corner_squares.each do |corner_square|
        position = corner_square if available_squares.include?(corner_square)
        break if assigned?(position)
      end
    end
  end
  position
end
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/CyclomaticComplexity

# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/PerceivedComplexity
# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/BlockNesting
def double_trap_blocking(brd, position)
  available_squares = empty_squares(brd)
  center_square = brd[5]
  # Block double trap scenario 1:
  # - when center is taken by computer and two opposing corners are taken by
  #   player
  #
  # Example:
  #     x |   |             x |   |             x |   | x
  #    ---+---+---         ---+---+---         ---+---+---
  #       | o |      -->      | o |      or       | o |
  #    ---+---+---         ---+---+---         ---+---+---
  #       |   | x           x |   | x             |   | x
  # - player can set a double trap by  moving to squares 3 or 7
  #
  # Counter-move:
  # - if no position assigned yet, check if center is taken by computer
  # - if it is, check if two opposing corners are taken by player
  #   - if it is, take an available middle square
  middle_squares = [2, 4, 6, 8]
  if !assigned?(position)
    if center_square == COMPUTER_MARKER
      if (brd[1] == PLAYER_MARKER && brd[9] == PLAYER_MARKER) ||
         (brd[3] == PLAYER_MARKER && brd[7] == PLAYER_MARKER)
        middle_squares.each do |middle_square|
          position = middle_square if available_squares.include?(middle_square)
          break if assigned?(position)
        end
      end
    end
  end
  # Block double trap scenario 2:
  # - when center is taken by computer and two adjacent middle squares are taken
  #   by player
  #
  # Example:
  #       | x |             x | x |
  #    ---+---+---         ---+---+---
  #     x | o |      -->    x | o |
  #    ---+---+---         ---+---+---
  #       |   |               |   |
  # - player can set a double trap by moving to square 1
  #
  # Counter-move:
  # - if no position assigned yet, check if center is taken by computer
  # - if it is, check if two adjacent middle squares are taken by player
  #   - if it is, take the corner between the middle squares
  if !assigned?(position)
    if center_square == COMPUTER_MARKER
      if brd[2] == PLAYER_MARKER && brd[6] == PLAYER_MARKER
        position = 3 if available_squares.include?(3)
      elsif brd[4] == PLAYER_MARKER && brd[8] == PLAYER_MARKER
        position = 7 if available_squares.include?(7)
      elsif brd[2] == PLAYER_MARKER && brd[4] == PLAYER_MARKER
        position = 1 if available_squares.include?(1)
      elsif brd[6] == PLAYER_MARKER && brd[8] == PLAYER_MARKER
        position = 9 if available_squares.include?(9)
      end
    end
  end
  # Block double trap scenario 3:
  # - when center is taken by computer and player has taken a corner square and
  #   an opposing middle square
  #
  # Example:
  #     x |   |             x |   |
  #    ---+---+---         ---+---+---
  #       | o |      -->      | o |
  #    ---+---+---         ---+---+---
  #       | x |             x | x |
  # - player can set a double trap by moving to square 7
  #
  # Counter-move:
  # - if no position assigned yet, check if center is taken by computer
  # - if it is, check if player has taken a corner and an opposing middle square
  #   - if it is, take middle square on the same side of trap
  if !assigned?(position)
    if center_square == COMPUTER_MARKER
      if (brd[1] == PLAYER_MARKER && brd[8] == PLAYER_MARKER) ||
         (brd[7] == PLAYER_MARKER && brd[2] == PLAYER_MARKER)
        position = 4 if available_squares.include?(4)
      elsif (brd[3] == PLAYER_MARKER && brd[8] == PLAYER_MARKER) ||
            (brd[9] == PLAYER_MARKER && brd[2] == PLAYER_MARKER)
        position = 6 if available_squares.include?(6)
      elsif (brd[7] == PLAYER_MARKER && brd[6] == PLAYER_MARKER) ||
            (brd[9] == PLAYER_MARKER && brd[4] == PLAYER_MARKER)
        position = 8 if available_squares.include?(8)
      elsif (brd[1] == PLAYER_MARKER && brd[6] == PLAYER_MARKER) ||
            (brd[3] == PLAYER_MARKER && brd[4] == PLAYER_MARKER)
        position = 2 if available_squares.include?(2)
      end
    end
  end
  position
end
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/PerceivedComplexity
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/BlockNesting

def random(brd)
  empty_squares(brd).sample
end

# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/PerceivedComplexity
# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/CyclomaticComplexity
def computer_marks!(brd, difficulty)
  position = nil
  if difficulty == "Easy"
    position = winning(brd, position) ||
               random(brd)
  elsif difficulty == "Medium"
    position = winning(brd, position) ||
               blocking(brd, position) ||
               random(brd)
  elsif difficulty == "Hard"
    position = winning(brd, position) ||
               blocking(brd, position) ||
               center(brd, position) ||
               random(brd)
  elsif difficulty == "Super Hard"
    position = winning(brd, position) ||
               blocking(brd, position) ||
               center(brd, position) ||
               double_trap_blocking(brd, position) ||
               random(brd)
  end
  brd[position] = COMPUTER_MARKER
end
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/PerceivedComplexity
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/CyclomaticComplexity

def play_piece!(brd, curr_plyr, difficulty)
  curr_plyr == "Player" ? player_marks!(brd) : computer_marks!(brd, difficulty)
end

def alternate_player(curr_plyr)
  curr_plyr == "Player" ? "Computer" : "Player"
end

def board_full?(brd)
  empty_squares(brd).size == 0
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).all?(PLAYER_MARKER)
      return "Player"
    elsif brd.values_at(*line).all?(COMPUTER_MARKER)
      return "Computer"
    end
  end
  nil
end

def display_result(brd)
  if someone_won?(brd)
    prompt "#{detect_winner(brd)} won!"
  else
    prompt messages("tie_result")
  end
  display_spacer
end

def next_round
  display_spacer
  prompt messages("first_to_five_wins")
  display_spacer
  prompt messages("press_any_key")
  STDIN.getch
end

def determine_winner(plyr_score, cmptr_score)
  plyr_score > cmptr_score ? "Player" : "Computer"
end

def display_final_score(brd, plyr_score, cmptr_score, winner)
  display_board(brd, plyr_score, cmptr_score)
  prompt "Game Over. #{winner} wins!"
  display_spacer
  display_spacer
  prompt "Final Score: Player: #{plyr_score}, Computer: #{cmptr_score}"
  display_spacer
  display_spacer
end

def play_again?
  prompt messages("play_again")
  answer = gets.chomp.downcase
  answer.start_with?("y")
end

def goodbye_msg
  display_spacer
  prompt messages("goodbye")
  display_spacer
  display_spacer
end

# program start
loop do
  board = initialize_board
  player_score = 0
  computer_score = 0

  greeting_msg

  difficulty = difficulty_selection
  display_selection(difficulty)

  first_player = first_player_selection
  display_first_player(first_player)

  # game outer loop
  loop do
    board = initialize_board
    display_board(board, player_score, computer_score)
    current_player = first_player

    # game inner loop
    loop do
      display_board(board, player_score, computer_score)
      break if someone_won?(board) || board_full?(board)
      play_piece!(board, current_player, difficulty)
      current_player = alternate_player(current_player)
    end

    display_result(board)
    player_score += 1 if detect_winner(board) == "Player"
    computer_score += 1 if detect_winner(board) == "Computer"
    break if player_score == 5 || computer_score == 5
    next_round
  end

  winner = determine_winner(player_score, computer_score)
  display_final_score(board, player_score, computer_score, winner)
  break unless play_again?
end

goodbye_msg
