module ColorGuard::Helper
  def feature_active?(feature, user = nil)
    ColorGuard.active?(feature, user)
  end
end
