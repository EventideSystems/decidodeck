# frozen_string_literal: true

# Controller for the home page
class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  layout 'home'

  sidebar_item :home

  def index
    if user_signed_in?
      redirect_to(dashboard_path)
    else
      render landing_page_template
    end
  end

  def privacy; end

  private

  def landing_page_template
    case current_theme
    when :free_sdg
      'themes/free_sdg/landing_page'
    else
      'index'
    end
  end
end
