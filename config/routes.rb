# frozen_string_literal: true

module Decidodeck
  class Routes < Hanami::Routes
    slice :main, at: "/" do
      use Main::AuthenticationApp

      root to: "home.show"

      resource :account, only: %i[show]
    end

    # Add your routes here. See https://guides.hanamirb.org/routing/overview/ for details.
  end
end
