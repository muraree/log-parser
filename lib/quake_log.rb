# frozen_string_literal: true

require_relative 'log_utils'
require_relative 'game'

class QuakeLog
  include LogUtils

  attr_reader :games

  def initialize(log_file = get_log_file_path)
    @log_file = log_file
    @games = []
    @current_game = nil
  end

  def parse_log_file
    read_from_file(@log_file) do |file|
      file.each do |line|
        if game_start?(line)
          game_name = "game_#{@games.length + 1}"
          @current_game = Game.new(game_name)
        elsif player_line?(line)
          player_name = get_player_name(line)
          @current_game.add_player(player_name)
        elsif kill_event?(line)
          killer, killed, kill_reason = get_kill_info_from_kill_event(line)
          kill_reason = kill_reason.to_sym
          kill_reason = :MOD_UNKNOWN unless MEANS_OF_DEATH.include?(kill_reason)
          @current_game.deal_with_kill_event(killer, killed, kill_reason)
        elsif game_over?(line)
          @games << @current_game if @current_game && !@games.include?(@current_game)
        else
          next
        end
      end
    end
  end

  def display_game_information(game_name)
    if game_name
      get_game_by_name(game_name)
    else
      @games
    end
  end

  def display_kill_reasons
    @games
  end

  def get_game_by_name(game_name)
    game = @games.detect { |g| g.game_name == game_name }
    return game if game

    "Error: Game #{game_name} not found."
    exit 1
  end
end
