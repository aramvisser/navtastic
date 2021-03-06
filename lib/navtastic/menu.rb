module Navtastic
  # Stores items generated by a definition block
  class Menu
    # Configuration settings per menu
    class Configuration
      # @return [String,nil] a url to prepend every item url with
      attr_accessor :base_url

      def initialize
        @base_url = nil
      end
    end

    include Enumerable

    # @return [Array<Item>] the items in this menu
    attr_reader :items

    # @return [Menu,nil] this parent of this menu
    attr_reader :parent

    # @return [Menu::Configuration] the configuration for this menu
    attr_reader :config

    # Create a new empty menu
    #
    # @param parent [Menu] the parent menu of this is submenu
    def initialize(parent = nil)
      @parent = parent

      @config = Menu::Configuration.new
      @current_item = nil
      @items = []
    end

    # @return [true] if this menu is the root menu
    # @return [false] if this menu is a submenu
    def root?
      @parent.nil?
    end

    # The depth of this menu
    #
    # The root menu always has depth 0.
    #
    # @return [Integer] the depth of this menu
    def depth
      if @parent
        @parent.depth + 1
      else
        0
      end
    end

    # Add a new item at the end of the menu
    #
    # @param name [String]the name to display in the menu
    # @param url [String] the url to link to, if the item is a link
    # @param options [Hash] extra confiration options
    #
    # @yield [submenu] block to generate a sub menu
    # @yieldparam submenu [Menu] the menu to be initialized
    def item(name, url = nil, options = {})
      # If only options were given and no url, move options to the right place
      if url.is_a?(Hash) && options.empty?
        options = url
        url = nil
      end

      item = Item.new(self, name, url, options)

      if block_given?
        submenu = Menu.new(self)

        submenu.config.base_url = url if options[:base_url] && url

        yield submenu
        item.submenu = submenu
      end

      @items << item
      register_item(item)

      item
    end

    def each
      @items.each do |item|
        yield item
      end
    end

    # Find an item in this menu matching the url
    #
    # @param url [String] the url of the item
    #
    # @return [Item] if an item with that url exists
    # @return [nil] if the item doens't exist
    def [](url)
      items_by_url[url]
    end

    # Sets the current active item by url
    #
    # @private
    #
    # @param current_url [String] the url of the current page
    def current_url=(current_url)
      @current_item = nil
      return if current_url.nil?

      # Sort urls from longest to shortest and find the first matching substring
      matching_item = items_by_url
                      .sort_by { |url, _item| -url.length }.to_h
                      .find { |url, _item| current_url.start_with? url }

      @current_item = matching_item[1] if matching_item
    end

    # @see file:README.md#Current_item documentation on how the current item is
    #   selected
    #
    # @return [Item,nil] the current active item
    def current_item
      if root?
        @current_item
      else
        @parent.current_item
      end
    end

    # The base url of this menu, including all parent base urls
    #
    # @return [String]
    def base_url
      base_url = config.base_url.to_s.dup
      base_url.prepend Navtastic.configuration.base_url.to_s if root?
      base_url.prepend @parent.base_url.to_s unless root?
      base_url = nil if base_url.empty?
      base_url
    end

    protected

    # Register a newly added item
    #
    # @param item [Item] the new item to register
    def register_item(item)
      return unless item.url

      if root?
        # The first item with a url is the default current item
        @current_item = item if @current_item.nil?
      else
        @parent.register_item(item)
      end
    end

    def items_by_url
      indexed_items = {}

      @items.each do |item|
        indexed_items[item.url] = item if item.url?
        indexed_items.merge!(item.submenu.items_by_url) if item.submenu?
      end

      indexed_items
    end
  end
end
