module Navtastic
  # A single menu item
  class Item
    # @return [String] the name to be displayed in the menu
    attr_reader :name

    # @return [String,nil] the url to link to, if item is a link
    attr_reader :url

    # Create a new item
    #
    # This should not be used directly. Use the {Menu#item} method instead.
    #
    # @private
    #
    # @param menu [Menu] the menu this items belongs to
    # @param name [String] the name to display when rendering
    # @param url [String] the url to link to, if the item is a link
    def initialize(menu, name, url = nil)
      @menu = menu
      @name = name
      @url = url
    end

    # Check if this item is the current item in the menu
    #
    # @return [Bool] if the item is the current item
    def current?
      @menu.current_item == self
    end

    # Quick overview of the item
    #
    # @private
    def inspect
      "#<Item \"#{name}\" [#{url}] current?:#{current?}>"
    end
  end
end
