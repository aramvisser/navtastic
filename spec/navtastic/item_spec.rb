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

  describe '#active?' do
    subject { item.active? }

    let(:menu) do
      menu = Navtastic::Menu.new
      menu.item "Root", '/' do |submenu|
        submenu.item "Sub", '/sub'
      end
      menu.item "Foo", '/foo'
      menu.current_url = current_url
      menu
    end

    context "when the item has an active child" do
      let(:item) { menu['/'] }
      let(:current_url) { '/sub' }

      it { is_expected.to eq true }
    end

    context "when the item does not have an active child" do
      let(:item) { menu['/'] }
      let(:current_url) { '/foo' }

      it { is_expected.to eq false }
    end

    context "when the item has no submenu" do
      let(:item) { menu['/sub'] }
      let(:current_url) { '/' }

      it { is_expected.to eq false }
    end

    context "when the item is the current item" do
      let(:item) { menu[current_url] }
      let(:current_url) { '/' }

      it { is_expected.to eq true }
    end
  end
end
