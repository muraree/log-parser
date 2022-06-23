# frozen_string_literal: true

require 'json'
require_relative 'kill'
require_relative 'player'

class Game

  attr_reader :game_name
  
  def initialize(game_name)
    @game_name = game_name
    @kills = []
    @players = []
  end

  def add_player(player_name)
    get_player_by_name(player_name) || create_new_player(player_name)
  end

  def deal_with_kill_event(killer, killed, kill_reason)
    killer_player = add_player(killer)
    killed_player = add_player(killed)

    killer_player.kill(killed_player)

    @kills << Kill.new(killer_player, killed_player, kill_reason)
  end

  def get_player_by_name(name)
    @players.detect { |player| player.name == name }
  end

  def output_game
    score_info = {}
    real_players.each do |player|
      score_info[player.name] = player.get_score
    end

    { @game_name => { total_kills: @kills.length,
                      players: player_names,
                      kills: score_info}
    }
  end

  def to_s
    JSON.pretty_generate(output_game)
  end

  def display_kill_reasons
    JSON.pretty_generate(generate_aggregation_kill_reasons)
  end

  def generate_aggregation_kill_reasons
    kill_reasons = {}
    @kills.each do |kill|
      kill_reasons[kill.kill_reason] ||= 0
      kill_reasons[kill.kill_reason] += 1
    end
    { @game_name => { kills_by_means: kill_reasons}}
  end

  private

  def player_names
    real_players.map(&:name)
  end

  def real_players
    @players.select {|player| player.name != '<world>'}
  end

  def create_new_player(name)
    player = Player.new(name)
    @players << player
    player
  end
end
