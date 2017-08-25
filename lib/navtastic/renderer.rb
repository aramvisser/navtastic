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
        render_menu(menu)
      end
    end

    # Starting a new root menu or submenu (e.g. `<ul>` tag)
    #
    # @param menu [Menu]
    # @return [Arbre::HTML::Tag]
    def menu_tag(menu)
      ul { yield }
    end

    # The container for every menu item (e.g. `<li>` tags)
    #
    # @param item [Item]
    # @return [Arbre::HTML::Tag]
    def item_tag(item)
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

    private
    
    # The complete structure of the menu.
    #
    # @param menu [Menu]
    # @return [Arbre::HTML::Tag]
    def render_menu(menu)
      menu_tag(menu) do
        menu.each do |item|
          item_tag(item) do
            item_content(item)
            render_menu(item.submenu) if item.submenu?
          end
        end
      end
    end
  end
end
