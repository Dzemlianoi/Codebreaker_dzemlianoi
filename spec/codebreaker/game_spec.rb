require 'spec_helper'

module Codebreaker
  RSpec.describe Game do
    let(:game) {Game.new}
    before do
      allow($stdout).to receive(:write)
    end
    context '#initialize' do
      it 'render is a kind of render' do
        expect(game.render).to be_a_kind_of(Render)
      end

      it 'options exists' do
        expect(game).to respond_to(:options)
      end

      it 'options should be a hash' do
        expect(game.options).to be_an_instance_of(Hash)
      end
    end

    context '#start' do
      it 'should call "new" method if scenario allowed' do
        allow(game).to receive_message_chain(:gets).and_return('new')
        allow(game).to receive(:new)
        expect(game).to receive(:new)
        game.start
      end

      it 'should call "exit" method if scenario allowed' do
        allow(game).to receive_message_chain(:gets).and_return('exit')
        allow(game).to receive(:exit)
        expect(game).to receive(:exit)
        game.start
      end

      it 'should call "stats" method if scenario allowed' do
        allow(game).to receive_message_chain(:gets).and_return('stats')
        allow(game).to receive(:stats)
        expect(game).to receive(:stats)
        game.start
      end
    end

    context 'new' do
      it 'should receive confirm settings' do
        allow(game).to receive(:game)
        allow(game).to receive(:confirm_settings)
        expect(game).to receive(:confirm_settings)
        game.send(:confirm_settings)
      end

      it 'should receive game' do
        allow(game).to receive(:confirm_settings)
        allow(game).to receive(:game)
        expect(game).to receive(:game)
        game.send(:new)
      end

      it 'secret code should not to be empty' do
        allow(game).to receive(:confirm_settings)
        allow(game).to receive(:game)
        game.send(:new)
        expect(game.options[:secret_code]).not_to be_empty
      end
    end

    context '#first_play' do
      it 'should return true if @stats not empty' do
        allow(game).to receive(:@stats) {['test']}
        expect(game.send(:first_play?)).to be_falsey
      end
    end

    context '#name_correct?' do
      it 'should return true if name isn\'t empty' do
        game.options[:name] = ''
        expect(game.send(:name_correct?)).to be_falsey
      end

      it 'should return false if name is empty' do
        game.options[:name] = 'test'
        expect(game.send(:name_correct?)).to be_truthy
      end
    end

    context '#diff_correct?' do
      it 'should return true if difficulties inlude current difficulty' do
        game.options[:difficulty] = :easy
        expect(game.send(:diff_correct?)).to be_truthy
      end

      it 'should return true if name isn\'t empty' do
        game.options[:difficulty] = :test
        expect(game.send(:diff_correct?)).to be_falsey
      end
    end

    context '#assign_options' do
      it 'game options should not be empty' do
        game.options[:difficulty] = :easy
        game.send(:asign_options)
        expect(game.options[:hints]).not_to be_nil
        expect(game.options[:hints_left]).not_to be_nil
        expect(game.options[:attempts]).not_to be_nil
        expect(game.options[:attempts_left]).not_to be_nil
      end
    end

    context '#generate_secret_code' do
      it 'should contains 4 letters from 0 to 6' do
        expect(game.send(:generate_secret_code)).to match(/[0-6]{4}/)
      end
    end

    context '#show_hint' do
      it 'should decrease by 1hints_left' do
        allow(game).to receive(:get_hint_digit)
        game.options[:hints_left] = 5
        expect{game.send(:show_hint)}.to change{game.options[:hints_left]}
      end

      it 'should not decrease hints_left if no more hints left' do
        allow(game).to receive(:get_hint_digit)
        game.options[:hints_left] = 0
        expect{game.send(:show_hint)}.not_to change{game.options[:hints_left]}

      end
    end

    context '#hint?' do
      it 'should return true if got HiNt' do
        game.current_code = 'HiNt'
        expect(game.send(:hint?)).to be_truthy
      end

      it 'should return false if got test' do
        game.current_code = 'test'
        expect(game.send(:hint?)).to be_falsey
      end
    end

    context '#get_hint_digit' do
      it 'hint_code_digits size should be decreased by 1' do
        game.hint_code_digits = '1234'
        expect{game.send(:get_hint_digit)}.to change{game.hint_code_digits}
      end
    end

    context '#handle_answer' do
      it 'should decrease attempts_left' do
        allow(game).to receive(:code_correct?){true}
        allow(game).to receive(:code_result)
        game.options[:attempts_left] = 5
        expect{game.send(:handle_answer)}.to change{game.options[:attempts_left]}
      end
    end

    context '#code_correct' do
      it 'should return false if code consists from wrong digits' do
        game.current_code = '1239'
        expect(game.send(:code_correct?)).to be_falsy
      end

      it 'should return false if code has mote than 4 digits' do
        game.current_code = '12391'
        expect(game.send(:code_correct?)).to be_falsy
      end

      it 'should return false if code consists letters' do
        game.current_code = '123a'
        expect(game.send(:code_correct?)).to be_falsy
      end
    end

    context '#win?' do
      it 'should return true if codes are equal' do
        game.current_code = '1234'
        game.options[:secret_code] = '1234'
        expect(game.send(:win?)).to be_truthy
      end

      it 'should return true if codes are equal' do
        game.current_code = '1234'
        game.options[:secret_code] = '2345'
        expect(game.send(:win?)).to be_falsey
      end
    end

    context '#code_result' do
      [
          ['6541', '6541', '++++'],
          ['1234', '5612', '--'],
          ['5566', '5600', '+-'],
          ['6235', '2365', '+---'],
          ['1234', '4321', '----'],
          ['1234', '1235', '+++'],
          ['1234', '6254', '++'],
          ['1234', '5635', '+'],
          ['1234', '4326', '---'],
          ['1234', '3525', '--'],
          ['1234', '2552', '-'],
          ['1234', '4255', '+-'],
          ['1234', '1524', '++-'],
          ['1234', '5431', '+--'],
          ['1234', '6666', ''],
          ['1115', '1231', '+-'],
          ['1231', '1111', '++']
      ].each do |i|
        it "should return #{i[2]} if code is - #{i[0]}, atttempt_code is #{i[1]}" do
          game.options[:secret_code] = i[0]
          game.current_code = i[1]
          expect(game.send(:code_result)).to eq(i[2])
        end
      end
    end
  end
end