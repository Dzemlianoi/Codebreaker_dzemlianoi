require 'spec_helper'

module Codebreaker
  RSpec.describe Game do
    context '#initialize' do
      it 'difficulties and options should be Hashes' do
        expect(subject.difficulties).to be_a_kind_of(Hash)
        expect(subject.options).to be_a_kind_of(Hash)
      end

      it 'secret code shouldnt be empty' do
        expect(subject.options[:secret_code].to_s).not_to be_empty
      end
    end

    context '#assign_game_options' do
      it 'game options should not be empty' do
        subject.send(:asign_game_options, 'Test', :easy)
        expect(subject.options[:hints]).not_to be_nil
        expect(subject.options[:name]).not_to be_nil
        expect(subject.options[:difficulty]).not_to be_nil
        expect(subject.options[:hints_left]).not_to be_nil
        expect(subject.options[:attempts]).not_to be_nil
        expect(subject.options[:attempts_left]).not_to be_nil
        expect(subject.hint_code_digits).not_to be_nil
      end
    end

    context '#get_hint' do
      it 'should return false if no more hints left' do
        allow(subject).to receive(:hints_left?) {false}
        expect(subject.get_hint).to be_eql(false)
      end

      it 'should change hints if hints left' do
        allow(subject).to receive(:hints_left) {true}
        allow(subject).to receive(:get_hint_digit)
        subject.options[:hints_left] = 10
        expect{subject.get_hint}.to change{subject.options[:hints_left]}.by(-1)
      end
    end

    context '#hints_left?' do
      it 'should be truthy if hints > 0' do
        subject.options[:hints_left] = 10
        expect(subject.hints_left?).to be_truthy
      end

      it 'should be falsey if hints < 0' do
        subject.options[:hints_left] = 0
        expect(subject.hints_left?).to be_falsey
      end
    end

    context '#win?' do
      it 'should return true if codes are equal' do
        subject.current_code = '1234'
        subject.options[:secret_code] = '1234'
        expect(subject.send(:win?)).to be_truthy
      end

      it 'should return true if codes are equal' do
        subject.current_code = '1234'
        subject.options[:secret_code] = '2345'
        expect(subject.send(:win?)).to be_falsey
      end
    end

    context '#generate_secret_code' do
      it 'should contains 4 letters from 0 to 6' do
        expect(subject.send(:generate_secret_code)).to match(/[0-6]{4}/)
      end
    end

    context '#get_hint_digit' do
      it 'hint_code_digits size should be decreased by 1' do
        subject.hint_code_digits = '1234'
        expect{subject.send(:get_hint_digit)}.to change{subject.hint_code_digits}
      end
    end

    context '#hints_left?' do
      it 'should be truthy if attempts > 0' do
        subject.options[:attempts_left] = 10
        expect(subject.send(:attempts_left?)).to be_truthy
      end

      it 'should be falsey if attempts < 0' do
        subject.options[:attempts_left] = 0
        expect(subject.send(:attempts_left?)).to be_falsey
      end
    end

    context '#marking_result' do
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
          subject.options[:secret_code] = i[0]
          subject.current_code = i[1]
          expect(subject.send(:marking_result)).to eq(i[2])
        end
      end
    end
  end
end