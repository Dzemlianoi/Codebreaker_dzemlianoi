module Codebreaker
  class Game
    attr_accessor :current_code, :secret_code, :difficulties, :difficulty,
                  :attempts_left, :hints_left, :hint_code_digits, :name,
                  :attempts_array, :hints_array

    def initialize(name, difficulty)
      @difficulties = Loader.load('difficulties')
      @name = name
      @difficulty = difficulty.to_sym
      init_game_options
    end

    def init_game_options
      @hints_left = difficulty_info[:hints]
      @attempts_left = difficulty_info[:attempts]
      @secret_code = generate_secret_code
      @hint_code_digits = secret_code.clone
      @attempts_array = []
      @hints_array = []
    end

    def get_hint
      return unless hints_left?
      @hints_left -= 1
      hint = get_hint_digit
      @hints_array.push(hint)
    end

    def hints_left?
      @hints_left > 0
    end

    def code_operations(current_code)
      @current_code = current_code
      @attempts_left -= 1
      @attempts_array.push(@current_code)
    end

    def win?
      @current_code == @secret_code
    end

    def loose?
      @attempts_left < 0
    end

    def last_chance
      @attempts_left == 1
    end

    def difficulty_info
      difficulties[@difficulty]
    end

    def marking_result(code = nil)
      answer = ''
      secret_copy = @secret_code.split('')
      current_copy = code ? @current_code.split('') : code.split('')
      secret_copy.each_with_index do |val, key|
        next unless val == current_copy[key]
        current_copy[key], secret_copy[key] = nil
        answer << '+'
      end

      [secret_copy, current_copy].each(&:compact!)

      current_copy.each do |digit|
        next unless secret_copy.include?(digit)
        answer << '-'
        secret_copy[secret_copy.find_index(digit)] = nil
      end
      answer
    end

    def to_h
      {
          name: @name,
          difficulty: @difficulty,
          attempts_left: @attempts_left,
          hints_left: @hints_left,
          secret_code: @secret_code,
          hints_array: @hints_array,
          attempts_array: @attempts_array,
          hint_code_digits: @hint_code_digits
      }
    end

    private

    def generate_secret_code
      Array.new(4) { rand(0..6)}.join
    end

    def get_hint_digit
      @hint_code_digits.slice!(rand(@hint_code_digits.size))
    end
  end
end

