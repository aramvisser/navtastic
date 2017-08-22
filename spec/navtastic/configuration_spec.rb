require 'spec_helper'

RSpec.describe Navtastic::Configuration do
  describe '.new' do
    subject(:configuration) { described_class.new }

    expected_defaults = {
      renderer: Navtastic::Renderer
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
    before { set_configuration renderer: :foo }

    it "sets the configuration values back to default" do
      expect { Navtastic.reset_configuration }
        .to change { Navtastic.configuration.renderer }
        .from(:foo)
        .to(Navtastic::Renderer)
    end
  end

  describe '.configure' do
    specify do
      expect { |b| Navtastic.configure(&b) }.to yield_with_args(described_class)
    end
  end
end
