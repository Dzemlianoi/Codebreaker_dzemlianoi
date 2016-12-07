require 'spec_helper'

module Codebreaker
  RSpec.describe Render do
    context '#initialize' do
      it '@phrases should not be empty' do
        expect(subject.instance_variable_get(:@phrases)).not_to be_empty
      end
    end

    context '#hello' do
      it 'key hello must be in @phrases' do
        expect(subject.instance_variable_get(:@phrases)).to have_key(:hello)
      end
    end

    context '#ask_name' do
      it 'key ask_name must be in @phrases' do
        expect(subject.instance_variable_get(:@phrases)).to have_key(:ask_name)
      end
    end

    context '#difficulties_show' do
      it 'key ask_difficulty must be in @phrases' do
        expect(subject.instance_variable_get(:@phrases)).to have_key(:ask_difficulty)
      end

      it 'key ask_difficulty_choice must be in @phrases' do
        expect(subject.instance_variable_get(:@phrases)).to have_key(:ask_difficulty_choice)
      end
    end

    context '#congratulations' do
      it 'key congratulations must be in @phrases' do
        expect(subject.instance_variable_get(:@phrases)).to have_key(:congratulations)
      end
    end

    context '#answers_hints_info' do
      it 'key hint_info must be in @phrases' do
        expect(subject.instance_variable_get(:@phrases)).to have_key(:hint_info)
      end

      it 'key ask_answer must be in @phrases' do
        expect(subject.instance_variable_get(:@phrases)).to have_key(:ask_answer)
      end
    end

    context '#no_hints' do
      it 'key no_hints must be in @phrases' do
        expect(subject.instance_variable_get(:@phrases)).to have_key(:no_hints)
      end
    end

    context '#hints_left_info' do
      it 'key hints_left must be in @phrases' do
        expect(subject.instance_variable_get(:@phrases)).to have_key(:hints_left)
      end

      it 'key right_digit must be in @phrases' do
        expect(subject.instance_variable_get(:@phrases)).to have_key(:right_digit)
      end
    end

    context '#win' do
      it 'key win must be in @phrases' do
        expect(subject.instance_variable_get(:@phrases)).to have_key(:win)
      end

      it 'key ask_for_save must be in @phrases' do
        expect(subject.instance_variable_get(:@phrases)).to have_key(:ask_for_save)
      end
    end

    context '#wrong_input' do
      it 'key wrong_input must be in @phrases' do
        expect(subject.instance_variable_get(:@phrases)).to have_key(:wrong_input)
      end
    end

    context '#loose' do
      it 'key loose must be in @phrases' do
        expect(subject.instance_variable_get(:@phrases)).to have_key(:loose)
      end
      it 'key right_code must be in @phrases' do
        expect(subject.instance_variable_get(:@phrases)).to have_key(:right_code)
      end
    end

    context '#no_stats' do
      it 'key no_stats must be in @phrases' do
        expect(subject.instance_variable_get(:@phrases)).to have_key(:no_stats)
      end
    end
  end
end
