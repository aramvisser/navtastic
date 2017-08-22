# Helpers that are used when testing
module NavtasticHelpers
  # Update the current configuration
  #
  # @param options [Hash] configuration settings to override
  def set_configuration(options)
    Navtastic.configure do |configuration|
      options.each do |key, value|
        configuration.send("#{key}=", value)
      end
    end
  end
end

RSpec.configure do |c|
  c.include NavtasticHelpers
end
