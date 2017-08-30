require 'spec_helper'

RSpec.describe Navtastic::Configuration do
  describe '.new' do
    subject(:configuration) { described_class.new }

    expected_defaults = {
      renderer: Navtastic::Renderer::Simple,
    }

    expected_defaults.each do |key, value|
      context "##{key}" do
        it "defaults to #{value}" do
          expect(configuration.send(key)).to eq value
        end
      end
    end
  end

  describe '.reset_configuration' do
    before { set_configuration renderer: :bulma }

    it "sets the configuration values back to default" do
      expect { Navtastic.reset_configuration }
        .to change { Navtastic.configuration.renderer }
        .from(Navtastic::Renderer::Bulma)
        .to(Navtastic::Renderer::Simple)
    end
  end

  describe '.configure' do
    specify do
      expect { |b| Navtastic.configure(&b) }.to yield_with_args(described_class)
    end
  end

  describe '#renderer=' do
    subject(:renderer_config) do
      configuration.renderer = renderer
      configuration.renderer
    end

    let(:configuration) { described_class.new }

    context "when the renderer parameter is a class" do
      let(:renderer) { Navtastic::Renderer::Simple }

      it "sets the renderer to that class" do
        expect(renderer_config).to eq renderer
      end
    end

    context "when the renderer is a known symbol" do
      let(:renderer) { :bulma }

      it "sets the renderer to the class for that symbol" do
        expect(renderer_config).to eq Navtastic::Renderer::Bulma
      end
    end

    context "when the renderer is not a known symbol" do
      let(:renderer) { :foo }

      it "raises an argument error" do
        expect { renderer_config }.to raise_error ArgumentError
      end
    end
  end
end
