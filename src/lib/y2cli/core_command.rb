require "y2cli/command"
require "y2cli/storage_command"

module Y2Cli
  class CoreCommand < Command
    def define_command
      parser.banner = "Usage: yast-core OPTIONS SUBCOMMAND OPTIONS"

      parser.on("-v", "--version", "Version number") do
        puts "0.0.1"
        exit
      end

      parser.on_tail("-h", "--help", "Show this message") do
        puts parser
        exit
      end
    end

    def perform_action
      case args.first
      when "storage"
        args.shift
        StorageCommand.new(args).run
      else
        puts parser
        exit
      end
    end
  end
end



