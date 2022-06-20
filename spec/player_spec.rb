# frozen_string_literal: true

require 'player'

describe Player do
  let(:player1) { Player.new('Example player1') }
  let(:player2) { Player.new('Example player2') }
  let(:player3) { Player.new('<world>') }
  let(:player4) { Player.new('Example player3', 5, 2, 1) }
  let(:player5) { Player.new('Example player1') }

  describe 'Kill' do
    it 'should increase kill times when player kills another player' do
      player1.kill(player2)
      expect(player1.kill_times).to eq(1)
      expect(player2.no_world_kill_times).to eq(1)
    end

    it 'should increase suicide times when player kills himself' do
      player1.kill(player1)
      expect(player1.world_kill_times).to eq(1)
    end

    it 'should increase suicide times when player is killed by <world>' do
      player3.kill(player1)
      expect(player1.world_kill_times).to eq(1)
    end
  end

  describe 'Get score' do
    it 'should get score 0 when player has no kill events' do
      expect(player1.get_score).to eq(0)
    end

    it 'should get correct score when player has kill events' do
      expect(player4.get_score).to eq(4)
    end
  end
end
