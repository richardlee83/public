# mortgage_calculator.rb

# configuration files
require 'yaml'

# constants
MESSAGES = YAML.load_file('mortgage_calculator.yml')

# methods
def messages(message)
  MESSAGES[message]
end

def prompt(message)
  puts "=> #{message}"
end

def get_input(category)
  prompt(messages(category))

  input = nil
  loop do
    input = gets.chomp.strip.delete('$').delete('%')
    numeric(input) && positive(input) ? break : error(category)
  end

  input
end

def numeric(input)
  !Float(input, exception: false) ? false : true
end

def positive(input)
  input.to_f > 0
end

def error(type)
  case type
  when 'loan'
    prompt(messages('loan_error'))
  when 'interest'
    prompt(messages('interest_error'))
  when 'duration'
    prompt(messages('duration_error'))
  end
end

def monthly_payment(loan, interest, duration)
  loan = loan.to_f
  interest_monthly = (interest.to_f / 100) / 12
  duration_months = duration.to_f

  if interest_monthly == 0
    loan / duration_months
  else
    loan * (interest_monthly / (1 - (1 + interest_monthly)**(-duration_months)))
  end
end

# program start
loop do # main loop
  prompt(messages('welcome'))
  prompt(messages('divider'))

  # get user input
  loan = get_input('loan')
  interest_percent = get_input('interest')
  duration_months = get_input('duration')

  # calculate monthly payment and output result
  result = monthly_payment(loan, interest_percent, duration_months)
  prompt("#{messages('payment')} #{result.round(2)}")

  # ask user whether to repeat program
  prompt(messages('repeat'))
  repeat = gets.chomp.strip

  break unless repeat.downcase == 'y' || repeat.downcase == 'yes'
end

# end program
prompt(messages('goodbye'))
