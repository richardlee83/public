# rps_bonus.rb

# configuration files
require 'yaml'

# constants
MESSAGES = YAML.load_file('rps_bonus.yml')
SELECTION = { rock: { input: ['r', 'rock'], defeats: ['lizard', 'scissors'] },
              paper: { input: ['p', 'paper'], defeats: ['rock', 'spock'] },
              scissors: { input: ['sc', 'scissors'],
                          defeats: ['paper', 'lizard'] },
              spock: { input: ['sp', 'spock'], defeats: ['scissors', 'rock'] },
              lizard: { input: ['l', 'lizard'], defeats: ['spock', 'paper'] } }

# methods
def prompt(message)
  puts "=> #{message}"
end

def messages(message)
  MESSAGES[message]
end

def player_input
  player_choice = nil

  loop do
    prompt(messages('player_input'))
    player_choice = convert_input_to_choice()

    SELECTION.key?(player_choice) ? break : prompt(messages('invalid_choice'))
  end

  player_choice
end

def convert_input_to_choice
  player_input = gets.chomp.downcase.strip

  player_choice = nil
  SELECTION.values.each do |value|
    if value[:input].include?(player_input)
      player_choice = SELECTION.key(value)
    end
  end

  player_choice
end

def display_choices(player_choice, computer_choice)
  player_choice = player_choice.to_s.capitalize
  computer_choice = computer_choice.capitalize

  puts ''
  prompt("You chose: #{player_choice}, Computer chose: #{computer_choice}")
end

def get_winner(player_choice, computer_choice)
  return 'player' if winner?(player_choice, computer_choice)
  return 'computer' if winner?(computer_choice, player_choice)
  'tie'
end

def winner?(first_player_choice, second_player_choice)
  SELECTION[first_player_choice][:defeats].include?(second_player_choice.to_s)
end

def display_winner(winning_player)
  case winning_player
  when 'player'
    prompt(messages('player_win_round'))
  when 'computer'
    prompt(messages('computer_wins_round'))
  when 'tie'
    prompt(messages('tie'))
  end
end

def display_score(player_score, computer_score)
  puts "=> Total score: You = #{player_score}, Computer = #{computer_score} "
end

def display_game_status(player_score, computer_score)
  if player_score == 3
    prompt(messages('player_win_game'))
  elsif computer_score == 3
    prompt(messages('computer_wins_game'))
  else
    prompt(messages('next_round'))
    gets
  end
end

def play_again?
  prompt(messages('repeat_play'))
  repeat = gets.chomp.downcase.strip

  repeat.downcase == 'y' || repeat.downcase == 'yes'
end

# program start
loop do # main loop for each game
  # starting scores
  player_score = 0
  computer_score = 0

  loop do # loop for each round
    # welcome screen and rules
    system('clear')
    prompt(messages('welcome'))
    prompt(messages('rules'))

    # determine player and computer choices
    player_choice = player_input()
    computer_choice = SELECTION.keys.sample
    display_choices(player_choice, computer_choice)

    # determine winner of current round
    winning_player = get_winner(player_choice, computer_choice)
    display_winner(winning_player)

    # update and display current scores
    player_score += 1 if winning_player == 'player'
    computer_score += 1 if winning_player == 'computer'

    display_score(player_score, computer_score)
    display_game_status(player_score, computer_score)

    # round ends when player or computer reaches 3 wins
    break if player_score == 3 || computer_score == 3
  end

  # ask user to play again
  break unless play_again? == true
end

# end program
prompt(messages('goodbye'))
