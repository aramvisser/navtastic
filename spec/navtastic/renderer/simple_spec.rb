require 'spec_helper'

RSpec.describe Navtastic::Renderer::Simple do
  describe '.render' do
    subject(:renderer) { described_class.render menu }

    let(:current_url) { '/' }
    let(:menu) do
      menu = Navtastic::Menu.new
      menu.item "Home", '/'
      menu.current_url = current_url
      menu
    end

    it "returns an instance of Navtastic::Renderer::Simple" do
      expect(renderer).to be_a described_class
    end
  end
end
