require 'arbre'

module Navtastic
  class Renderer
    # This renderer adds a few css classes to the base renderer
    class Simple < Navtastic::Renderer
      def css_classes(item, context)
        classes = super(item, context)

        case context
        when :item_container
          classes << 'current' if item.current?
        end

        classes
      end
    end
  end
end
