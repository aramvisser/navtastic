require 'arbre'

module Navtastic
  # Generate HTML based on a menu.
  #
  # This base renderer only generates a structure and no css classes.
  #
  # The actual HTML generation is done using the
  # [Arbre](https://github.com/activeadmin/arbre) gem.
  #
  # Calling `#to_s` will return the HTML.
  class Renderer < Arbre::Context
    # Create a new renderer
    #
    # @param menu [Menu]
    # @param options [Hash]
    #
    # @return [Self]
    def self.render(menu, options = {})
      new(root: menu, options: options) do
        render_menu(root)
      end
    end

    # Start a new root menu or submenu (e.g. `<ul>` tag)
    #
    # @param menu [Menu]
    # @return [Arbre::HTML::Tag]
    def menu_tag(menu) # rubocop:disable Lint/UnusedMethodArgument
      ul { yield }
    end

    # The container for every menu item (e.g. `<li>` tags)
    #
    # @param item [Item]
    # @return [Arbre::HTML::Tag]
    def item_tag(item) # rubocop:disable Lint/UnusedMethodArgument
      li { yield }
    end

    # The item itself (e.g. `<a>` tag for links or `<span>` for text)
    #
    # @param item [Item]
    # @return [Arbre::HTML::Tag]
    def item_content(item)
      if item.url
        a(href: item.url) { item.name }
      else
        span { item.name }
      end
    end

    # Check if a submenu should be displayed inside the item container of after
    # it.
    #
    # Defaults to `true`.
    #
    # @param item [Item]
    # @return [bool]
    def menu_inside_container?(item) # rubocop:disable Lint/UnusedMethodArgument
      true
    end

    private

    # Render the menu structure
    #
    # @param menu [Menu]
    # @return [Arbre::HTML::Tag]
    def render_menu(menu)
      menu_tag(menu) do
        menu.each do |item|
          render_item(item)
        end
      end
    end

    # Render the item structure
    #
    # @param item [Item]
    # @return [Arbre::HTML::Tag]
    def render_item(item)
      element = item_tag(item) do
        render_item_content(item)
      end

      # Add custom css classes to the element
      element.class_list << item.options[:class] if item.options[:class]

      return unless item.submenu? && !menu_inside_container?(item)
      render_menu(item.submenu)
    end

    # Render the item content
    #
    # @param item [Item]
    # @return [Arbre::HTML::Tag]
    def render_item_content(item)
      element = item_content(item)

      # Add custom css classes to the element
      if item.options[:content_class] && element.respond_to?(:class_list)
        element.class_list << item.options[:content_class]
      end

      return unless item.submenu? && menu_inside_container?(item)
      render_menu(item.submenu)
    end
  end
end
