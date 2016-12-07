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

      it 'console is a kind of console' do
        expect(subject.render).to be_a_kind_of(Render)
      end

      it 'console is a kind of console' do
        expect(subject.instance_variable_get(:@stats)).to be_a_kind_of(Array)
      end
    end

    context '#start' do
      it 'should call "new" method if scenario allowed' do
        allow(subject).to receive_message_chain(:gets).and_return('new')
        allow(subject).to receive(:new)
        expect(subject).to receive(:new)
        subject.start
      end

      it 'should call "exit" method if scenario allowed' do
        allow(subject).to receive_message_chain(:gets).and_return('exit')
        allow(subject).to receive(:exit)
        expect(subject).to receive(:exit)
        subject.start
      end

      it 'should call "stats" method if scenario allowed' do
        allow(subject).to receive_message_chain(:gets).and_return('stats')
        allow(subject).to receive(:stats)
        expect(subject).to receive(:stats)
        subject.start
      end
    end

    context 'new' do
      it 'should receive confirm settings' do
        allow(subject).to receive(:gaming)
        allow(subject).to receive(:confirm_settings)
        expect(subject).to receive(:confirm_settings)
        subject.send(:new)
      end

      it 'should receive console' do
        allow(subject).to receive(:confirm_settings)
        allow(subject).to receive(:gaming)
        expect(subject).to receive(:gaming)
        subject.send(:new)
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

    context '#once_mote' do
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