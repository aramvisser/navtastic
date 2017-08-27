require 'arbre'

module Navtastic
  class Renderer
    # This renderer adds css classes and structure for the foundation 6
    # framework
    class Foundation6 < Navtastic::Renderer
      def menu_tag(menu)
        class_list = ['menu']
        class_list << 'vertical' if vertical?
        class_list << 'nested' unless menu.root?

        ul(class: class_list.join(' ')) { yield }
      end

      def item_tag(item)
        element = super(item)
        element.class_list << 'is-active' if item.current?
        element
      end

      def item_content(item)
        element = super(item)
        element.class_list << 'menu-text' unless item.url
        element
      end

      private

      def vertical?
        true
      end
    end
  end
end
