module Codebreaker
  class Game
    attr_accessor :options, :current_code, :result, :render, :hint_code_digits
    attr_reader :stats
    ALLOWED_SCENARIOS = %w(new exit stats)

    def initialize
      @difficulties = Loader.load('difficulties')
      @stats = Loader.load('statistics')
      self.render = Render.new
      self.options = {}
      render.hello
    end

    def start
      scenario = gets.chomp.downcase
      return send(scenario.to_s) if ALLOWED_SCENARIOS.include? scenario
      start
    end

    private

    def new
      confirm_settings
      options[:secret_code] = generate_secret_code
      self.hint_code_digits = options[:secret_code].clone
      game
    end

    def confirm_settings
      render.ask_name
      options[:name] = gets.chomp until name_correct?

      render.difficulties_show(@difficulties)
      options[:difficulty] = gets.chomp.to_sym until diff_correct?

      asign_options
    end

    def stats
      first_play? ? render.no_stats : render.stat_describe(@stats)
      start
    end

    def first_play?
      @stats.none?
    end

    def name_correct?
      !options[:name].to_s.empty?
    end

    def diff_correct?
      @difficulties.include?(options[:difficulty])
    end

    def asign_options
      options[:hints] = @difficulties[options[:difficulty]][:hints]
      options[:hints_left] = options[:hints].to_i
      options[:attempts] = @difficulties[options[:difficulty]][:attempts]
      options[:attempts_left] = options[:attempts]
    end

    def generate_secret_code
      (0...4).map { rand(1..6) }.join
    end

    def game
      render.answers_hints_info
      (0..options[:attempts_left]).each do
        self.current_code = gets.chomp.downcase
        hint? ? show_hint : handle_answer
        return win if win?
      end
      render.loose(options[:secret_code])
    end

    def show_hint
      return render.no_hints if options[:hints_left].zero?
      options[:hints_left] -= 1
      render.hints_left_info(options[:hints_left], get_hint_digit)
    end

    def hint?
      current_code.downcase == 'hint'
    end

    def get_hint_digit
      hint_code_digits.slice!(rand(hint_code_digits.size))
    end

    def handle_answer
      return render.wrong_input unless code_correct?
      options[:attempts_left] -= 1
      render.answer(code_result)
    end

    def code_correct?
      current_code.match(/^[0-6]{4}$/)
    end

    def win?
      current_code == options[:secret_code]
    end

    def code_result
      answer = ''
      secret_code_copy = options[:secret_code].split('')
      current_code_copy = current_code.split('')
      (0...4).each do |k|
        if options[:secret_code][k] == current_code[k]
          answer << '+'
          current_code_copy[k] = nil
          secret_code_copy[k] = nil
        end
      end
      minuses = current_code_copy.compact & secret_code_copy.compact
      minuses.size.times { answer << '-' }
      answer
    end

    def save_result
      @stats = Loader.load('statistics') if @stats.none?
      @stats.push(options)
      Loader.save('statistics', @stats)
    end

    def win
      render.win
      save_result if gets.chomp.downcase == 'y'
    end
  end
end
