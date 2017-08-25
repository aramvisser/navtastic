require 'spec_helper'

RSpec.describe Navtastic::Renderer do
  describe '#menu_inside_container?' do
    # Create a test rendered that chooses menu position fro  options hash
    class MenuInsideRenderer < described_class
      def menu_inside_container?(_item)
        options[:inside]
      end
    end

    subject(:renderer) { MenuInsideRenderer.render(menu, inside: inside) }

    let(:menu) do
      menu = Navtastic::Menu.new
      menu.item "First" do |submenu|
        submenu.item "Second"
      end
      menu
    end

    context "when it returns true" do
      let(:inside) { true }

      it "renders the submenu inside the item container" do
        expect(renderer.find_by_tag('li').first.children.count).to eq 2
      end
    end

    context "when it returns false" do
      let(:inside) { false }

      it "renders the submenu after the item container" do
        expect(renderer.find_by_tag('li').first.children.count).to eq 1
      end
    end
  end
end
