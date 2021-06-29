require "yast"
require "y2cli/command"
require "y2storage"
require "y2storage/autoinst_proposal"

module Y2Cli
  class StorageCommand < Command
    def define_command
      parser.banner = "Usage: yast-core storage OPTIONS"

      parser.on("--actions", "Show actions to perform") do
        options.show_actions = true
      end

      parser.on("--config CONFIG", "A config file") do |config|
        options.config = config
      end
    end

    def perform_action
      Yast.import "ProductFeatures"

      config = Yast::XML.XMLToYCPFile(options.config)
      proposal = nil

      Y2Storage::StorageManager.instance.probe

      if config["partitioning"].is_a?(Hash)
        Yast::ProductFeatures.Import(config)
        settings = Y2Storage::ProposalSettings.new_for_current_product
        proposal = Y2Storage::GuidedProposal.new(settings: settings)
      else
        proposal = Y2Storage::AutoinstProposal.new(partitioning: config["partitioning"])
      end

      proposal.propose
      devicegraph = proposal.devices

      if options.show_actions
        puts Y2Storage::ActionsPresenter.new(devicegraph.actiongraph).to_s
        return
      end

      # if commit
      #   # Y2Storage::StorageManager.instance.staging = devicegraph
      #   # Y2Storage::StorageManager.instance.commit
      #   puts "Let's not break the system"
      # else
        Y2Storage::YamlWriter.write(devicegraph, $stdout)
      # end
    end

    def options
      @options ||= Options.new
    end

    class Options
      def initialize
        @show_actions = false
        @config = nil
      end

      attr_accessor :show_actions, :config
    end
  end
end



