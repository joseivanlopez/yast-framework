require "optparse"

module Y2Cli
  class Command
    def initialize(args)
      @args = args.dup

      define_command
    end

    def run
      parse

      perform_action
    end

    private

    attr_reader :args, :parser

    def define_command
    end

    def parse
      parser.order!(args)
    rescue OptionParser::InvalidOption
      puts parser
      exit(1)
    end

    def perform_action
    end

    def parser
      @parser ||= OptionParser.new
    end
  end
end



