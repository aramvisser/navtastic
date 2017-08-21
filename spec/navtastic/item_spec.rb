require 'spec_helper'

RSpec.describe Navtastic::Item do
  describe '#current?' do
    let(:menu) { Navtastic::Menu.new }
    let!(:item) { menu.item "Home", '/' }

    it "calls the Menu#current_item method" do
      allow(menu).to receive :current_item
      item.current?
      expect(menu).to have_received :current_item
    end
  end
end
