# frozen_string_literal: true

require 'quake_log'

describe QuakeLog do
  describe 'Parse log file' do
    it 'should return the correct number of games' do
      parser = QuakeLog.new
      parser.parse_log_file
      expect(parser.games.length).to eq(21)
    end
  end
end
