require 'spec_helper'
require 'support/matchers/current_item.rb'

RSpec.describe Navtastic::Menu do
  subject(:menu) do
    menu = described_class.new

    menu.item "Home" do |submenu|
      submenu.item "Posts", '/posts'
      submenu.item "Featured", '/posts/featured'
    end

    menu.item "About", '/about'

    menu
  end

  describe '.new' do
    subject(:menu) { described_class.new }

    context "when the menu has no parent" do
      specify { expect(menu.items).to be_empty }
      specify { expect(menu).not_to have_current_item }

      it "has a depth of 0" do
        expect(menu.depth).to eq 0
      end
    end

    context "when the menu has a parent" do
      subject(:submenu) { described_class.new(menu) }

      specify { expect(submenu.items).to be_empty }
      specify { expect(submenu).not_to have_current_item }

      it "has a depth of parent.depth + 1" do
        expect(submenu.depth).to eq(menu.depth + 1)
      end
    end
  end

  describe '#item' do
    specify { expect { menu.item "Test" }. to change { menu.items.size }.by 1 }

    it "returns the inserted item" do
      expect(menu.item("Test")).to eq menu.items.last
    end

    context "with 1 argument" do
      before { menu.item name }

      let(:name) { "Test" }
      let(:item) { menu.items.last }

      it "sets the name" do
        expect(item.name).to eq name
      end

      it "leaves the url empty" do
        expect(item.url).to eq nil
      end
    end

    context "with 2 arguments" do
      before { menu.item name, url }

      let(:name) { "Test" }
      let(:url) { "/url" }
      let(:item) { menu.items.last }

      it "sets the name" do
        expect(item.name).to eq name
      end

      it "sets the url" do
        expect(item.url).to eq url
      end
    end

    context "when the item has a submenu" do
      let(:item) { menu.items.first }

      it "adds the menu to the itme" do
        expect(item.submenu).not_to eq nil
      end
    end
  end

  describe '#items' do
    it "includes every item defined in this menu" do
      expect(menu.items.count).to eq 2
    end
  end

  describe '#each' do
    specify { expect { |b| menu.each(&b) }.to yield_control.exactly(2).times }
    specify { expect(menu).to all be_a Navtastic::Item }
  end

  describe '#[]' do
    it "returns the item for the given url in this menu" do
      expect(menu['/about'].name).to eql 'About'
    end

    it "returns the item for the given url in a submenu" do
      expect(menu['/posts/featured'].name).to eql 'Featured'
    end

    it "returns nil when the url doesn't exist" do
      expect(menu['/foo']).to be nil
    end
  end

  describe '#current_item' do
    subject(:current_item) { menu.current_item }

    context "when the menu has no items" do
      let(:menu) { described_class.new }

      it { is_expected.to eq nil }
    end

    context "when the current url was not set" do
      it "points to the first item with a url" do
        expect(current_item).to eq menu['/posts']
      end
    end

    context "when the current url was set" do
      before { menu.current_url = url }

      let(:url) { '/about' }

      it "points to the item matching the url" do
        expect(current_item).to eq menu[url]
      end
    end

    context "when the current url matches an item in a submenu" do
      before { menu.current_url = url }

      let(:url) { '/posts' }

      it "points to the item in the submenu" do
        expect(current_item).to eq menu[url]
      end
    end

    context "when the current menu has a parent" do
      before { menu.current_url = url }

      subject(:submenu) { menu.items.first.submenu }

      let(:url) { '/about' }

      it "asks the parent menu for the current item" do
        allow(menu).to receive :current_item
        submenu.current_item
        expect(menu).to have_received :current_item
      end
    end
  end

  describe '#current_url=' do
    before { menu.current_url = current_url }

    context "when the url matches an item directly" do
      let(:current_url) { '/posts' }

      it "sets the item matching the url as current" do
        expect(menu).to have_current_item(menu[current_url])
      end
    end

    context "when the url matches the beginning of an item" do
      let(:current_url) { '/posts/featured/2' }

      it "sets the item with the longest matching url as current" do
        expect(menu).to have_current_item(menu['/posts/featured'])
      end
    end

    context "when the url matches nothing without a root item" do
      let(:current_url) { '/foo/bar' }

      it { is_expected.not_to have_current_item }
    end

    context "when the url matches nothing with a root item" do
      subject(:menu) do
        menu = described_class.new
        menu.item "Home", '/'
        menu
      end

      let(:current_url) { '/foo/bar' }

      it "sets the root item as current" do
        expect(menu).to have_current_item(menu['/'])
      end
    end
  end
end
