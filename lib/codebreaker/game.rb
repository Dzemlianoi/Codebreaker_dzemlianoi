module Codebreaker
  class Game
    attr_accessor :options, :current_code, :hint_code_digits, :difficulties

    def initialize
      self.difficulties = Loader.load('difficulties')
      self.options = {}
      options[:secret_code] = generate_secret_code
    end

    def asign_game_options (name, difficulty)
      options[:name] = name
      options[:difficulty] = difficulty
      options[:hints] = difficulties[difficulty][:hints]
      options[:hints_left] = options[:hints].to_i
      options[:attempts] = difficulties[difficulty][:attempts]
      options[:attempts_left] = options[:attempts]
      self.hint_code_digits = options[:secret_code].clone
    end

    def get_hint
      return false unless hints_left?
      options[:hints_left] -= 1
      get_hint_digit
    end

    def hints_left?
      options[:hints_left] > 0
    end

    def code_operations(current_code)
      self.current_code = current_code
      options[:attempts] -= 1
      marking_result
    end

    def win?
      self.current_code == options[:secret_code]
    end

    private

    def generate_secret_code
      Array.new(4) { rand(0..6)}.join
    end

    def get_hint_digit
      hint_code_digits.slice!(rand(hint_code_digits.size))
    end

    def attempts_left?
      options[:attempts_left] > 0
    end

    def marking_result
      answer = ''
      secret_code_copy = options[:secret_code].split('')
      current_code_copy = current_code.split('')
      secret_code_copy.each_with_index do |val, key|
        next unless val == current_code_copy[key]
        current_code_copy[key] =nil
        secret_code_copy[key] = nil
        answer << '+'
      end
      minuses = current_code_copy.compact & secret_code_copy.compact
      minuses.size.times { answer << '-' }
      answer
    end
  end
end
