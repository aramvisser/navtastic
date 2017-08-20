require 'spec_helper'

RSpec.describe Navtastic do
  subject(:define_menu) do
    described_class.define menu_name do |menu|
      menu.item 'a', '/'
    end
  end

  let(:menu_name) { "test" }

  describe '.define' do
    context "when a block was given" do
      it "doesn't raise an error" do
        expect { define_menu }.not_to raise_error
      end

      it "stores the menu in the store" do
        expect { define_menu }.to(change { described_class.all_menus.count })
      end

      it "converts a string to a symbol in the store" do
        define_menu
        expect(described_class.all_menus).to include menu_name.to_sym
      end
    end

    context "when no block was given" do
      subject(:define_menu) { described_class.define :test }

      it "raises an ArgumentError" do
        expect { define_menu }.to raise_error ArgumentError
      end
    end
  end

  describe '.render' do
    before { define_menu }

    subject(:renderer) { described_class.render(menu_name, '/') }

    context "when the menu was found" do
      specify { expect(renderer).to be_a Navtastic::Renderer }
    end

    context "when the menu was not found" do
      subject(:renderer) { described_class.render("foo", '/') }

      specify { expect { renderer }.to raise_error KeyError }
    end
  end
end
