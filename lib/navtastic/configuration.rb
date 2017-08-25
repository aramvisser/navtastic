module Navtastic # :nodoc:
  # Configuration settings
  class Configuration
    # The default renderer to use when displaying a menu
    #
    # Defaults to {Navtastic::Renderer::Simple}
    #
    # @return any class that responds to the `.render` method
    attr_accessor :renderer

    def initialize
      @renderer = Navtastic::Renderer::Simple
    end
  end

  # @return [Navtastic::Configuration] current configuration
  def self.configuration
    @configuration ||= Configuration.new
  end

  # This will reset the configuration back to defaults
  def self.reset_configuration
    @configuration = nil
  end

  # Modify Navtastic's current configuration
  #
  # @example Modify the current configuration
  #   Navtastic.configure do |config|
  #     config.setting = :updated
  #   end
  #
  # @yieldparam [Navtastic::Configuration] current Navtastic configuration
  def self.configure
    yield configuration
  end
end
