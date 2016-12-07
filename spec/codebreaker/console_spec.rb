require 'spec_helper'

module Codebreaker
  RSpec.describe Console do
    before do
      allow($stdout).to receive(:write)
    end
    context '#initialize' do
      it 'render is a kind of Render' do
        expect(subject.render).to be_a_kind_of(Render)
      end

      it 'game is a kind of game' do
        expect(subject.game).to be_a_kind_of(Game)
      end

      it '@stats is a kind of array' do
        expect(subject.instance_variable_get(:@stats)).to be_a_kind_of(Array)
      end
    end

    context '#start' do
      ['new', 'exit', 'stats'].each do |action|
        it "should call #{action} method if scenario allowed" do
          allow(subject).to receive(:gets) {action}
          allow(subject).to receive(action.to_sym)
          expect(subject).to receive(action.to_sym)
          subject.start
        end
      end
    end

    context 'new' do
      around(:each) do |example|
        RSpec::Mocks.with_temporary_scope do
          allow(subject).to receive(:gaming)
          allow(subject).to receive(:confirm_settings)
          example.run
          subject.send(:new)
        end
      end

      ['gaming', 'confirm_settings'].each do |operation|
        it "should receive #{operation}" do
          expect(subject).to receive(operation.to_sym)
        end
      end
    end

    context '#name_correct?' do
      it 'should return true if name isn\'t empty' do
        expect(subject.send(:name_correct?, 1234)).to be_truthy
      end

      it 'should return true if name isn\'t empty' do
        expect(subject.send(:name_correct?, '')).to be_falsey
      end
    end

    context '#diff_correct?' do
      before(:each) do
        allow(subject.game).to receive(:difficulties) {[:easy, :hard, :medium]}
      end

      it 'should return true if difficulties include current difficulty' do
        expect(subject.send(:diff_correct?, :easy)).to be_truthy
      end

      it 'should return false if diff isn\'t in the array'  do
        expect(subject.send(:diff_correct?, :test)).to be_falsey
      end
    end

    context 'adopt user operation' do
      [
          ['hint', :show_hint],
          ['exit', :exit],
          ['1234', :retrieve_answer]
      ].each do |i|
        it "should return #{i[1]} if input is - #{i[0]}" do
          subject.current_input = i[0]
          allow(subject).to receive(i[1])
          expect(subject).to receive(i[1])
          subject.send(:adopt_user_operation)
        end
      end
    end

    context '#show_hint' do
      it 'should return render.no_hints if no hints' do
        allow(subject.game).to receive(:hints_left?) {true}
        expect(subject.render).to receive(:no_hints)
        subject.send(:show_hint)
      end
    end

    context '#code_correct' do
      ['1239', '12391', '123a', '111', 'aaaa'].each do |num|
        it "should return false if code is #{num}" do
          subject.current_input = num
          expect(subject.send(:code_correct?)).to be_falsey
        end
      end

      [
          '1111','0000', '2222', '3333', '4444',
          '5555', '6666', '1234', '3456'
      ].each do |num|
        it "should return false if code is #{num}" do
          subject.current_input = num
          expect(subject.send(:code_correct?)).to be_truthy
        end
      end
    end

    context '#accept?' do
      it 'should be truthy if gets - y' do
        allow(subject).to receive(:gets) {'Y'}
        expect(subject.send(:accept?)).to be_truthy
      end

      it 'should be falsey if gets - test' do
        allow(subject).to receive(:gets) {'test'}
        expect(subject.send(:accept?)).to be_falsey
      end
    end

    context '#once_more' do
      it 'should have render.once_more' do
        allow(subject).to receive(:accept?) {false}
        allow(subject).to receive(:exit)
        expect(subject.render).to receive(:once_more)
        subject.send(:once_more)
      end

      it 'should return exit if not accept?' do
        allow(subject).to receive(:accept?) {false}
        expect(subject.send(:once_more)).to receive(:exit)
      end
    end
  end
end