# Remove all stored menus before every test
RSpec.configure do |config|
  config.before(:each) do
    Navtastic.instance_variable_get(:@menu_store).clear
  end
end
