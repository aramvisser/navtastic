require 'arbre'

module Navtastic
  class Renderer
    # This renderer only adds a `current` css class to the current item
    class Simple < Navtastic::Renderer
      def item_tag(item)
        li(class: current_css_class(item)) { yield }
      end

      private

      def current_css_class(item)
        item.current? ? 'current' : nil
      end
    end
  end
end
