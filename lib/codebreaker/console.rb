module Codebreaker
  class Console
    attr_accessor :render, :current_input, :game
    attr_reader :stats
    ALLOWED_SCENARIOS = %w(new exit stats)

    def initialize
      @stats = Loader.load('statistics')
      self.render = Render.new
      self.game = Game.new
      render.hello
    end

    def start
      scenario = gets.chomp.downcase
      return send(scenario.to_s) if ALLOWED_SCENARIOS.include? scenario
      render.wrong_command
      start
    end

    private

    def new
      confirm_settings
      gaming
    end

    def confirm_settings
      render.ask_name
      name = gets.chomp until name_correct?(name)
      render.difficulties_show(game.difficulties)
      difficulty = gets.chomp.to_sym until diff_correct?(difficulty)
      game.asign_game_options(name, difficulty)
    end

    def stats
      @stats.none? ? render.no_stats : render.stat_describe(@stats)
      start
    end

    def name_correct?(name)
      !name.to_s.empty?
    end

    def diff_correct?(difficulty)
      game.difficulties.include?(difficulty)
    end

    def gaming
      render.answers_hints_info
      (0..game.options[:attempts_left]).each do
        self.current_input = gets.chomp.downcase
        adopt_user_operation
        return win if game.win?
      end
      loose
    end

    def adopt_user_operation
      case current_input
        when 'hint'
          show_hint
        when 'exit'
          exit
        else
          retrieve_answer
      end
    end

    def show_hint
      return render.no_hints unless game.hints_left?
      render.hints_left_info(game.get_hint, game.options[:hints_left])
    end

    def retrieve_answer
      return render.wrong_input unless code_correct?
      puts game.code_operations(current_input)
    end

    def code_correct?
      current_input.match(/^[0-6]{4}$/)
    end

    def win
      render.win
      save_result if accept?
      once_more
    end

    def loose
      render.loose
      once_more
    end

    def accept?
      gets.chomp.downcase == 'y'
    end

    def once_more
      render.once_more
      return Console.new.start if accept?
      exit
    end

    def save_result
      @stats = Loader.load('statistics') if @stats.none?
      @stats.push(game.options)
      Loader.save('statistics', @stats)
    end
  end
end