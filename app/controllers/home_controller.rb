# frozen_string_literal: true

# Controller for the home page
class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  layout 'home'

  sidebar_item :home

  def index
    redirect_to(dashboard_path) if user_signed_in?
  end

  def contributors; end

  def privacy; end
end
