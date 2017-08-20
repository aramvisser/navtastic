require 'spec_helper'
require 'support/matchers/current_item.rb'

RSpec.describe Navtastic::Menu do
  subject(:menu) do
    menu = described_class.new
    menu.item "Home"
    menu.item "Posts", '/posts'
    menu.item "About", '/about'
    menu
  end

  describe '.new' do
    subject(:menu) { described_class.new }

    let(:params) { { x: 1 } }

    specify { expect(menu.items).to be_empty }
    specify { expect(menu).not_to have_current_item }
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
  end

  describe '#each' do
    specify { expect { |b| menu.each(&b) }.to yield_control.exactly(3).times }
    specify { expect(menu).to all be_a Navtastic::Item }
  end

  describe '#[]' do
    it "returns the item for the given url" do
      expect(menu['/about'].name).to eql 'About'
    end

    it "returns nil when the url doesn't exist" do
      expect(menu['/foo']).to be nil
    end
  end

  describe '#current_url!' do
    let(:current_url) { '/posts' }

    before { menu.current_url! current_url }

    it "sets the item matching the url as current" do
      expect(menu).to have_current_item(menu[current_url])
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
      before { menu.current_url!(url) }

      let(:url) { '/about' }

      it "points to the item matching the url" do
        expect(current_item).to eq menu[url]
      end
    end
  end
end
