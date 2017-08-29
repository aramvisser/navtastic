require 'arbre'

module Navtastic
  class Renderer
    # This renderer adds css classes and structure for the bootstrap 4
    # framework
    class Bootstrap4 < Navtastic::Renderer
      def menu_tag(_menu)
        class_list = ['nav']
        class_list << 'flex-column' if vertical?

        ul(class: class_list.join(' ')) { yield }
      end

      def item_tag(item)
        element = super(item)
        element.class_list << 'nav-item'
        element
      end

      def item_content(item)
        element = super(item)
        element.class_list << 'nav-link'
        element.class_list << 'active' if item.current?
        element
      end

      private

      def vertical?
        true
      end
    end
  end
end
