require 'arbre'

module Navtastic
  class Renderer
    # This renderer adds css classes and structure for the bulma.io framework
    # @see file:README.md#Bulma documentation on renderer options
    class Bulma < Navtastic::Renderer
      def submenu_inside_container?(item)
        !(labels? && item.menu.root?)
      end

      def menu_tag(menu)
        if labels? && menu.root?
          nav(class: 'menu') { yield }
        else
          ul(class: 'menu-list') { yield }
        end
      end

      def item_tag(item)
        if labels? && item.menu.root?
          para(class: 'menu-label') { yield }
        else
          li { yield }
        end
      end

      def item_content(item)
        element = super(item)

        element.class_list << 'is-active' if item.current?

        element
      end

      private

      def labels?
        options[:root_labels]
      end
    end
  end
end
