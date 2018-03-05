module Navtastic
  # Helper methods for ActionView
  module ViewHelpers
    def render_menu(menu, options = {})
      Navtastic.render menu, request.fullpath, options
    end
  end

  # Setup hot reload and add helper to ApplicationHelper
  class Railtie < ::Rails::Railtie
    initializer "navtastic_railtie.initialize_configuration" do |app|
      Navtastic.configuration.reload_renderer = !app.config.eager_load
      ActiveSupport.on_load(:action_view) { include Navtastic::ViewHelpers }
    end

    config.to_prepare do
      Dir["app/menus/*.rb"].each { |file| load file }
    end
  end
end
