# frozen_string_literal: true

module Users
  # Controller for accepting Terms and Conditions
  class AcceptTermsController < ApplicationController
    skip_before_action :check_accepted_terms

    def new
      return unless current_user.accepted_terms?

      redirect_to root_path, notice: 'You have already accepted the Terms and Conditions.'
    end

    def create
      current_user.accept_terms!
      redirect_to root_path, notice: 'Thank you for accepting the Terms and Conditions.'
    end
  end
end
