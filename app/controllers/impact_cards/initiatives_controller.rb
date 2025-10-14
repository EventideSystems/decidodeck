# frozen_string_literal: true

module ImpactCards
  # Controller for Initiatives, nested under ImpactCards
  class InitiativesController < ::InitiativesController
    sidebar_item :impact_cards
    menu_item :workspace

    def show
      @impact_card = Scorecard.find(params[:impact_card_id])
      authorize(@impact_card, :show?)

      @initiative = @impact_card.initiatives.find(params[:id])
      authorize(@initiative, :edit_data?)

      @focus_areas_groups = @impact_card.data_model.focus_area_groups.order(:position)

      @grouped_checklist_items = @initiative.checklist_items_ordered_by_ordered_focus_area

      add_breadcrumbs
    end

    private

    def add_breadcrumbs
      add_breadcrumb @impact_card.class.model_name.human.pluralize, :impact_cards_path
      add_breadcrumb @impact_card.name, impact_card_path(@impact_card)
      add_breadcrumb @initiative.name
    end
  end
end
