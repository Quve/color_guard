module ColorGuard::Helper
  def feature_active?(feature, user = nil)
    user = current_user if user.nil? && defined?(:current_user)

    ColorGuard.active?(feature, user)
  end
end
