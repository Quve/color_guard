require "color_guard/middleware"

RSpec.describe ColorGuard::Middleware do
  let(:app) do
    Proc.new do |env|
      @store = Thread.current[:color_guard_store]
      "Response"
    end
  end
  let(:env) { { "QUERY_STRING" => "" } }
  subject{ ColorGuard::Middleware.new(app) }

  describe "#call" do
    it "creates a new store on the thead for the duration of the call" do
      subject.call(env)
      expect(@store).not_to be_nil
    end

    it "clears the store from the thread after the call" do
      subject.call(env)
      expect(Thread.current[:color_guard_store]).to be_nil
    end

    it "includes a url parameter store if its in the config" do
      subject.config[:allow_url] = true
      subject.call(env)
      param_store = @store.stores[0]
      expect(param_store).to be_a(ColorGuard::Store::UrlParameter)
    end

    it "includes a cookie store if its in the config" do
      subject.config[:allow_cookies] = true
      subject.call(env)
      cookie_store = @store.stores[0]
      expect(cookie_store).to be_a(ColorGuard::Store::Cookie)
    end

    it "puts the url first if both url and cookie are configured" do
      subject.config[:allow_cookies] = true
      subject.config[:allow_url] = true
      subject.call(env)
      param_store = @store.stores[0]
      cookie_store = @store.stores[1]
      expect(param_store).to be_a(ColorGuard::Store::UrlParameter)
      expect(cookie_store).to be_a(ColorGuard::Store::Cookie)
    end

    it "just uses the base store if no url or cookie config" do
      subject.call(env)
      expect(@store).not_to be_a(ColorGuard::Store::Stack)
    end

    it "returns the app response" do
      expect(subject.call(env)).to eq("Response")
    end
  end
end
