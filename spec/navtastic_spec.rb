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

    subject(:render) { described_class.render(menu_name, '/', params) }

    let(:params) { {} }

    context "when the menu was found" do
      specify { expect(render).to be_a described_class.configuration.renderer }
    end

    context "when the menu was not found" do
      subject(:render) { described_class.render("foo", '/') }

      specify { expect { render }.to raise_error KeyError }
    end

    context "when the renderer was updated in the configuration" do
      let(:mock_renderer) { class_double(Navtastic::Renderer::Simple) }

      before { set_configuration renderer: mock_renderer }

      it "calls `.render` on the class in the configuration" do
        allow(mock_renderer).to receive :render
        render
        expect(mock_renderer)
          .to have_received(:render).with(Navtastic::Menu, Hash)
      end
    end

    context "when rendering options have been set in the configuration" do
      before { set_configuration renderer_options: { foo: :bar } }

      it "passes the options to the renderer" do
        expect(render.options).to eq(foo: :bar)
      end
    end

    context "when params contains a renderer key" do
      before { set_configuration renderer_options: { foo: :bar } }

      let(:params) { { renderer: { foo: :foo, key: :value } } }

      it "passes the options to the renderer" do
        expect(render.options[:key]).to eq :value
      end

      it "merges them with the globally configured settings" do
        expect(render.options[:foo]).to eq :foo
      end
    end

    context "when render gets called twice in a row" do
      before do
        described_class.render(menu_name, '/', renderer: { foo: :bar })
      end

      it "won't use the renderer params from the first call" do
        expect(render.options[:foo]).to be_nil
      end
    end
  end
end
