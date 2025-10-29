# frozen_string_literal: true

module ImpactCards
  # Controller for ImpactCard details
  class SharingController < ApplicationController
    include ActiveTabItem

    sidebar_item :impact_cards
    menu_item :workspace
    tab_item :sharing

    def index
      @scorecard = Scorecard.find(params[:impact_card_id])
      authorize(@scorecard, :show?)

      add_breadcrumb @scorecard.class.model_name.human.pluralize, :impact_cards_path
      add_breadcrumb @scorecard.name, impact_card_sharing_index_path(@scorecard)
    end
  end
end
