class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def redirect_to_profile_if_signed_in
    redirect_to current_user if signed_in?
  end
end
