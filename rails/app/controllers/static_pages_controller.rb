class StaticPagesController < ApplicationController
  before_action :redirect_to_profile_if_signed_in

  def home
  end
end
