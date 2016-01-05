require 'rack'
require 'erb'
require 'color_guard'
require 'color_guard/middleware'

BODY = <<-EOS
  <h3>Do you see Bill?</h3>
  <% if ColorGuard.active?(:bill_murray) %>
    <img src="http://www.fillmurray.com/g/200/400" alt="bill">
  <% end %>
  <% if ColorGuard.active?(:unicorn) %>
    <marquee behavior="scroll" direction="right">
      <img src="https://d.gr-assets.com/hostedimages/1396762972ra/9184449.gif" alt="unicorn">
    </marquee>
  <% end %>
EOS

def build_page_body
  renderer = ERB.new(BODY)
  renderer.result(binding).to_s
end

app = Proc.new do |env|
  [ '200',
    { 'Content-Type' => 'text/html'},
    [ build_page_body ]
  ]
end
app = ColorGuard::Middleware.new(app, allow_cookies: true, allow_url: true)

Rack::Handler::WEBrick.run app
