# frozen_string_literal: true

# Controller for the home page
class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  layout 'home'

  sidebar_item :home

  def index
    redirect_to(dashboard_path) if user_signed_in?

    case current_theme
    when :free_sdg
      render 'home/landing_pages/free_sdg' and return
    else
      render 'index'
    end
  end

  def privacy; end
end
