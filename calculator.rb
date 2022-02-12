# calculator.rb

# configuration files
require 'yaml'
MESSAGES = YAML.load_file('calculator_messages.yml')

# set language: en = English, fr = French
LANG = 'en'

# methods
def messages(message, lang='en')
  MESSAGES[lang][message]
end

def prompt(message)
  puts "=> #{message}"
end

def valid_integer(num)
  num.to_i.to_s == num
end

def valid_float(num)
  num.to_f.to_s == num
end

def valid_operator(num)
  ['1', '2', '3', '4'].include?(num)
end

def number?(input)
  valid_integer(input) || valid_float(input)
end

def operator_to_message(op)
  word = case op
         when '1'
           messages('add', LANG)
         when '2'
           messages('subtract', LANG)
         when '3'
           messages('multiply', LANG)
         when '4'
           messages('divide', LANG)
         end

  word
end

# main program start
prompt(messages('welcome', LANG))

# ask for user name and validate
name = ''
loop do
  prompt(messages('name', LANG))
  name = gets.chomp

  if name == ''
    prompt(messages('name_error', LANG))
  else
    break
  end
end

# greet user
prompt("#{messages('greet', LANG)} #{name}!")

# main loop
loop do
  # ask for first number and validate
  number1 = ''
  loop do
    prompt(messages('first_number', LANG))
    number1 = gets.chomp

    if number?(number1) == true
      break
    else
      prompt(messages('number_error', LANG))
    end
  end

  # ask for second number and validate
  number2 = ''
  loop do
    prompt(messages('second_number', LANG))
    number2 = gets.chomp

    if number?(number2) == true
      break
    else
      prompt(messages('number_error', LANG))
    end
  end

  # ask for operator and validate
  operator = ''
  loop do
    prompt(messages('operator', LANG))
    operator = gets.chomp

    if valid_operator(operator) == true
      break
    else
      prompt(messages('operator_error', LANG))
    end
  end

  # calculate result
  prompt(operator_to_message(operator))

  # if either number is a float
  if valid_float(number1) || valid_float(number2)
    result = case operator
             when '1'
               number1.to_f + number2.to_f
             when '2'
               number1.to_f - number2.to_f
             when '3'
               number1.to_f * number2.to_f
             when '4'
               number1.to_f / number2.to_f
             end
  else # if both numbers are integers
    result = case operator
             when '1'
               number1.to_i + number2.to_i
             when '2'
               number1.to_i - number2.to_i
             when '3'
               number1.to_i * number2.to_i
             when '4'
               number1.to_f / number2.to_f
             end
  end

  # output result
  prompt("#{messages('result', LANG)} #{result}")

  # ask user whether to calculate again
  prompt(messages('repeat', LANG))
  answer = gets.chomp
  break unless answer.downcase == 'y'
end

# end program
prompt(messages('goodbye', LANG))
