# frozen_string_literal: true

require 'optparse'
require_relative 'lib/quake_log'

class QuakeGame
  def self.parse(args)
    options = {}
    opts = OptionParser.new do |opt|
      opt.banner = 'Usage: ruby main.rb [options]'
      opt.separator ''
      opt.separator 'Specific options:'
      opt.on('-k', '--kill-reason', 'Display aggregation of kill reasons.') do
        options[:kill_reason] = true
      end

      opt.on("-f Name", "--file Name",
              "Specify file path.") do |value|
        options[:file] = value
      end

      opt.on("-k", "--kill-reason",
              "Display kill reasons.") do
        options[:kill_reason] = true
      end

      opt.on('-g NAME', '--game-name Name',
              'Display information for a game.') do |value|
        options[:game_name] = value
      end
    end
    opts.parse!(args)
    options
  end

  options = QuakeGame.parse(ARGV)
  log_parser = options[:file] ? QuakeLog.new(options[:file]) : QuakeLog.new
  log_parser.parse_log_file

  if options[:kill_reason]
    puts log_parser.display_kill_reasons.map { |game| game.display_kill_reasons }
  else
    puts log_parser.display_game_information(options[:game_name])
  end
end
