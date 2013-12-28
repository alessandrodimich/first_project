module SessionsHelper

  def signed_in_user
    unless current_user
      store_location
      redirect_to login_url, notice: "Please sign in."
    end
  end


end
