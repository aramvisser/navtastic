module Navtastic
  # A single menu item
  class Item
    # @return [Menu] the containing menu
    attr_reader :menu

    # @return [String] the name to be displayed in the menu
    attr_reader :name

    # @return [String,nil] the url to link to if item is a link, nil otherwise
    attr_reader :url

    # @return [Hash] extra options to configure individual items
    attr_reader :options

    # @return [Menu,nil] the submenu of this item, if defined
    attr_accessor :submenu

    # Create a new item
    #
    # This should not be used directly. Use the {Menu#item} method instead.
    #
    # @private
    #
    # @param menu [Menu] the menu this items belongs to
    # @param name [String] the name to display when rendering
    # @param url [String] the url to link to, if the item is a link
    # @param options [Hash] extra configuration options
    def initialize(menu, name, url = nil, options = {})
      @menu = menu
      @name = name
      @url = url
      @options = options

      @submenu = nil
    end

    # Check if this item is the current item in the menu
    #
    # @see file:README.md#Current_item documentation on how the current item is
    #   selected
    #
    # @return [Bool] if the item is the current item
    def current?
      @menu.current_item == self
    end

    # Check if the item has a current child in its submenu (or deeper)
    #
    # Also returns true if this is the current item.
    #
    # @see file:README.md#Current_item documentation on how the current item is
    #   selected
    #
    # @return [Bool] if the item is the current item
    def active?
      return true if current?
      return false unless submenu

      submenu.any?(&:active?)
    end

    # @return [Bool] true if the item has a submenu, false other
    def submenu?
      !@submenu.nil?
    end

    def inspect
      "#<Item \"#{name}\" [#{url}] current?:#{current?}>"
    end

    # Check if item has a link or not
    #
    # @return [Bool]
    def url?
      !url.nil?
    end
  end
end
