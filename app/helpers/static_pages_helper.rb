module StaticPagesHelper
  def signed_in?
    current_user.present?
  end
end
