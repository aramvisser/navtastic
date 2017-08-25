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
    #
    # @return [Self]
    def self.render(menu)
      new(menu: menu) do
        menu(menu)
      end
    end

    # Starting a new root menu or submenu (e.g. `<ul>` tag)
    #
    # @param menu [Menu]
    # @return [Arbre::HTML::Tag]
    def menu(menu)
      ul do
        menu.each do |item|
          item_container item
        end
      end
    end

    # The container for every menu item (e.g. `<li>` tags)
    #
    # @param item [Item]
    # @return [Arbre::HTML::Tag]
    def item_container(item)
      li(class: css_classes_string(item, :item_container)) do
        item_content item

        menu(item.submenu) if item.submenu?
      end
    end

    # The item itself (e.g. `<a>` tag for links or `<span>` for text)
    #
    # @param item [Item]
    # @return [Arbre::HTML::Tag]
    def item_content(item)
      if item.url
        a(href: item.url) { item.name }
      else
        span item.name
      end
    end

    # Decide which css classes are needed for an item
    #
    # For example, {#item_container} uses this to retrieve the css class for
    # the current active item.
    #
    # This method is ideal for overriding in a subclass.
    #
    # @param item [Item] the current item that is rendered
    # @param context [Symbol] which method is asking for the css classes
    #
    # @return [Array<String>] list of css classes to apply to the HTML element
    def css_classes(item, context) # rubocop:disable Lint/UnusedMethodArgument
      []
    end

    # Same as {css_classes} method, but joins classes together in a string
    #
    # @see css_classes
    #
    # @return [String]
    def css_classes_string(item, context)
      css_classes(item, context).join ' '
    end
  end
end
