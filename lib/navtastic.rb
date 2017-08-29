require 'navtastic/configuration'
require 'navtastic/item'
require 'navtastic/menu'
require 'navtastic/renderer'
require 'navtastic/renderer/bootstrap4'
require 'navtastic/renderer/bulma'
require 'navtastic/renderer/foundation6'
require 'navtastic/renderer/simple'
require 'navtastic/version'

# Main module containing some convenience methods
module Navtastic
  # @private
  #
  # @return [Hash<Object,Block>] all stored menus
  @menu_store = {}

  # Define a new menu to be rendered later
  #
  # @example Define a new menu
  #   Navtastic.define :main do |menu, params|
  #     menu.item "Home", "/"
  #   end
  #
  # @param name the name of the menu
  #
  # @yield [menu, params] block to generate a new menu
  # @yieldparam menu [Menu] the menu to be initialized
  # @yieldparam params [Hash] runtime parameters
  #
  # @raise [ArgumentError] if no block was given
  def self.define(name, &block)
    raise ArgumentError, "no block given" unless block_given?

    name = name.to_sym if name.is_a? String
    @menu_store[name] = block
  end

  # Render a stored menu
  #
  # The `params` parameter is passed along to the block in {Navtastic.define}.
  #
  # If `params` contains a `:renderer` key, it's removed from the hash and
  # passed to the renderer instead. Look at the renderer documentation to see
  # which options are supported.
  #
  # @param name the name of the defined menu
  # @param current_url [String] the url of the current page
  # @param params [Hash] runtime parameters
  # @option params [Hash] :renderer Options passed to the renderer
  #
  # @raise [KeyError] if the menu was not defined
  #
  # @return [Renderer] the renderer for the menu
  def self.render(name, current_url, params = {})
    name = name.to_sym if name.is_a? String
    block = @menu_store[name]

    raise KeyError, "menu not defined: #{name.inspect}" if block.nil?

    # Remove renderer options from parameters
    renderer_options = params.delete(:renderer) || {}

    menu = Menu.new
    block.call(menu, params)
    menu.current_url = current_url
    Navtastic.configuration.renderer.render(menu, renderer_options)
  end

  # A list of all defined menus
  #
  # @return [Array]
  def self.all_menus
    @menu_store.keys
  end
end
