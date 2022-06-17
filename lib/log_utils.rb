# frozen_string_literal: true

module LogUtils
  LOG_FILE_NAME = 'quake.log'
  INIT_GAME_REGREX = /InitGame/.freeze
  END_GAME_REGREX = /-----/.freeze
  PLAYER_REGREX = /ClientUserinfoChanged: \d n\\(.*?)\\/.freeze
  KILL_REGREX = /Kill:.*:\s(.*)\skilled\s(.*)\sby\s(.*)/.freeze
  MEANS_OF_DEATH = %i[
    MOD_UNKNOWN
    MOD_SHOTGUN
    MOD_GAUNTLET
    MOD_MACHINEGUN
    MOD_GRENADE
    MOD_GRENADE_SPLASH
    MOD_ROCKET
    MOD_ROCKET_SPLASH
    MOD_PLASMA
    MOD_PLASMA_SPLASH
    MOD_RAILGUN
    MOD_LIGHTNING
    MOD_BFG
    MOD_BFG_SPLASH
    MOD_WATER
    MOD_SLIME
    MOD_LAVA
    MOD_CRUSH
    MOD_TELEFRAG
    MOD_FALLING
    MOD_SUICIDE
    MOD_TARGET_LASER
    MOD_TRIGGER_HURT
    MOD_NAIL
    MOD_CHAINGUN
    MOD_PROXIMITY_MINE
    MOD_KAMIKAZE
    MOD_JUICED
    MOD_GRAPPLE
  ].freeze
  
  def get_log_file_path
    File.expand_path("../../quake_logs/#{LOG_FILE_NAME}", __FILE__)
  end

  def read_from_file(filename)
    file = File.open(filename, 'r')
    yield file if block_given?
  rescue Errno::ENOENT => e
    puts "File not found: #{filename}"
    raise e
  rescue Errno::EACCES => e
    puts "File permission denied: #{filename}"
    raise e
  rescue => e
    puts "IO error: #{e.message}"
    raise e
  ensure
    file&.close if file
  end

  def game_start?(line)
    line =~ INIT_GAME_REGREX ? true : false
  end

  def game_over?(line)
    line =~ END_GAME_REGREX ? true : false
  end

  def player_line?(line)
    line =~ PLAYER_REGREX ? true : false
  end

  def get_player_name(line)
    line =~ PLAYER_REGREX
    $1
  end

  def kill_event?(line)
    line =~ KILL_REGREX ? true : false
  end

  def get_kill_info_from_kill_event(line)
    line =~ KILL_REGREX
    killer = $1
    killed = $2
    kill_reason = $3
    return [killer, killed, kill_reason]
  end

end