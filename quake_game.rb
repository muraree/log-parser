require 'optparse'
require_relative 'lib/quake_log_parser'

class Optparser
  def self.parse(args)
    options = {}

    opts = OptionParser.new do |opts|
      opts.banner = "Usage: ruby main.rb [options]"

      opts.separator ""
      opts.separator "Specific options:"

      opts.on("-f Name", "--file Name",
              "Specify the log file path.") do |value|
        options[:file] = value
      end

      opts.on("-k", "--kill-reason",
              "Display aggregation of kill reasons.") do
        options[:kill_reason] = true
      end

      opts.on('-g NAME', '--game-name Name',
              'Display information for a single game.') do |value|
        options[:game_name] = value
      end

      opts.separator ""
      opts.separator "Common options:"

      opts.on_tail("-h", "--help", "Show this message.") do
        puts opts
        exit
      end
    end

    opts.parse!(args)
    options
  end
end

options = Optparser.parse(ARGV)

log_parser = options[:file] ? QuakeLogParser.new(options[:file]) : QuakeLogParser.new
log_parser.parse_log_file

if options[:kill_reason]
  log_parser.display_kill_reasons(options[:game_name])
else
  log_parser.display_game_information(options[:game_name])
end