class ColorGuard::FeaturesController < ActionController::Base
  layout 'color_guard'

  def index
    @features = ColorGuard.features
  end
end
