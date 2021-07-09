class AccountActivationsController < ApplicationController
  # rubocop:disable Metrics/AbcSize
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      create_session(user)
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
  # rubocop:enable Metrics/AbcSize
end
