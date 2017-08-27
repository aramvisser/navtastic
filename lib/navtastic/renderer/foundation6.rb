require 'arbre'

module Navtastic
  class Renderer
    # This renderer adds css classes and structure for the foundation 6
    # framework
    # @see file:README.md#Foundation_Configuration documentation on foundation
    #   renderer options
    class Foundation6 < Navtastic::Renderer
      def menu_tag(menu)
        class_list = ['menu']
        class_list << 'vertical' if vertical?
        class_list << 'nested' unless menu.root?

        list = ul(class: class_list.join(' ')) { yield }

        if drilldown? && menu.root?
          list.class_list << 'drilldown'
          list.set_attribute('data-drilldown', true)
        end

        list
      end

      def item_tag(item)
        element = super(item)
        element.class_list << 'is-active' if item.current?
        element
      end

      def item_content(item)
        element = if item.url?
                    a(href: item.url) { item.name }
                  elsif drilldown?
                    a(href: '#') { item.name }
                  else
                    span(class: 'menu-text') { item.name }
                  end

        if drilldown? && item.active? && options[:active_class]
          element.class_list << options[:active_class]
        end

        element
      end

      private

      def vertical?
        true
      end

      def drilldown?
        options[:style] == :drilldown
      end
    end
  end
end
