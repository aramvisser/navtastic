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

  describe '#url' do
    subject(:url) { item.url }

    let(:menu) { Navtastic::Menu.new }

    context "when the item has a url" do
      let(:item) { menu.item "A", '/a' }

      it "returns that url" do
        expect(url).to eq '/a'
      end
    end

    context "when the item doesn't have a url" do
      let(:item) { menu.item "A" }

      it { is_expected.to eq nil }
    end

    context "when the the menu has a base_url" do
      before { menu.config.base_url = '/admin' }

      let(:item) { menu.item "Settings", '/settings' }

      it "prepends the base url to the item" do
        expect(url).to eq '/admin/settings'
      end
    end

    context "when the parent and sub menu have a base_url" do
      let(:submenu) { Navtastic::Menu.new menu }
      let(:item) { submenu.item "Things", '/things' }

      before do
        menu.config.base_url = '/admin'
        submenu.config.base_url = '/settings'
      end

      it "prepends all base urls to the item" do
        expect(url).to eq '/admin/settings/things'
      end
    end

    context "when the item is set to be as root" do
      before { menu.config.base_url = '/admin' }

      let(:item) { menu.item "Home", '/home', root: true }

      it "doesn't prepend the base url to the item" do
        expect(url).to eq '/home'
      end
    end
  end
end
