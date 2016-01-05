require "color_guard"
require "ostruct"

RSpec.describe ColorGuard::Store do
  describe ".build" do
    context "if the store is in the configuration" do
      let(:config) do
        OpenStruct.new(store: [:cookie, { "color_guard.feature" => "true" }])
      end

      it "creates the correct store type with the correct options" do
        store = ColorGuard::Store.build(config)
        expect(store).to be_a(ColorGuard::Store::Cookie)
        expect(store.find("feature")).not_to be_nil
      end
    end

    context "if the store is not in the configuration" do
      let(:config) { OpenStruct.new(store: nil) }

      it "returns a noop store" do
        expect(ColorGuard::Store.build(config)).to be_a(ColorGuard::Store::Noop)
      end
    end
  end
end
