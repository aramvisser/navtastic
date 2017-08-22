# Remove all stored menus and reset configuration before every test
RSpec.configure do |config|
  config.before(:each) do
    Navtastic.instance_variable_get(:@menu_store).clear
    Navtastic.reset_configuration
  end
end
