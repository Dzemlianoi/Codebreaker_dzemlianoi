module Codebreaker
  class Game
    attr_accessor :current_code, :secret_code, :difficulties, :difficulty,
                  :attempts_left, :hints_left, :hint_code_digits, :name

    def initialize
      self.difficulties = Loader.load('difficulties')
      self.secret_code = generate_secret_code
    end

    def asign_game_options (name, difficulty)
      self.name = name
      self.difficulty= difficulty
      self.hints_left = difficulty_info[:hints]
      self.attempts_left = difficulty_info[:attempts]
      self.hint_code_digits = secret_code.clone
    end

    def get_hint
      return unless hints_left?
      self.hints_left -= 1
      get_hint_digit
    end

    def hints_left?
      hints_left > 0
    end

    def code_operations(current_code)
      self.current_code = current_code
      self.attempts_left -= 1
      marking_result
    end

    def win?
      current_code == secret_code
    end

    def to_h
      {
          name: name,
          difficulty: difficulty,
          attempts: difficulty_info[:attempts],
          attempts_left: attempts_left,
          hints: difficulty_info[:hints],
          hints_left: hints_left,
          secret_code: secret_code
      }
    end

    private

    def generate_secret_code
      Array.new(4) { rand(0..6)}.join
    end

    def get_hint_digit
      hint_code_digits.slice!(rand(hint_code_digits.size))
    end

    def attempts_left?
      attempts_left > 0
    end

    def marking_result
      answer = ''
      secret_code_copy = secret_code.split('')
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


    def difficulty_info
      difficulties[self.difficulty]
    end
  end
end
