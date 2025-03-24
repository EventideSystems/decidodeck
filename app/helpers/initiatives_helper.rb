# frozen_string_literal: true

# Helper methods for presenting initiative data
module InitiativesHelper
  def applicable_date_range(initiative)
    return '' if initiative.started_at.blank? && initiative.finished_at.blank?

    start_date = initiative.started_at&.strftime('%b %Y')
    end_date = initiative.finished_at&.strftime('%b %Y')

    return "Starts at #{start_date}" if end_date.blank?
    return "Ends at #{end_date}" if start_date.blank?

    safe_join([start_date, end_date], ' to ')
  end

  def scorecard_label(initiative) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    if initiative.new_record? || initiative.scorecard.nil?
      current_workspace.scorecard_types.map { |type| type.model_name.human }
                       .join(' / ')
    else
      safe_join(
        [
          content_tag(:span, initiative.scorecard.model_name.human.to_s, style: 'margin-right: 10px'),
          link_to(
            content_tag(
              :i,
              '',
              class: 'fa fa-external-link'
            ),
            transition_card_path(initiative.scorecard),
            id: 'initiative-detail-scorecard-link'
          )
        ]
      )
    end
  end

  def initiatives_characteristics_title(initiative)
    case initiative.scorecard.type
    when 'TransitionCard' then 'Initiative Characteristics'
    when 'SustainableDevelopmentGoalAlignmentCard' then 'Initiative SDGs Targets'
    end
  end

  def mail_to_contact_email(initiative)
    return '' if initiative&.contact_email.blank?

    mail_to initiative.contact_email, initiative.contact_email, class: 'text-blue-500 hover:text-blue-700 underline'
  end

  def linked_initiative_warning(initiative)
    return '' if initiative.blank?
    return '' if initiative.scorecard.blank?

    return '' unless initiative.new_record?
    return '' unless initiative.scorecard.linked?
    return '' if initiative.linked_initiative.present?

    content_tag(:div, class: 'form-group row alert alert-warning') do
      content_tag(:strong, 'Note: ', class: 'mr-1') +
        "This initiative belongs to a linked #{initiative.scorecard.model_name.human}. " \
        'Saving this initiative will automaically create a linked initiative in the other card.'
    end
  end

  def initiative_scorecard_types
    current_workspace.scorecard_types.map do |scorecard_type|
      [scorecard_type.model_name.human.pluralize, scorecard_type.name]
    end
  end

  private

  # SMELL: Duplicate of code in initiatives_controller.rb
  def scorecard_type_from_params(params)
    if params[:scope].blank? || !params[:scope].in?(%w[transition_cards sdgs_alignment_cards])
      current_workspace.default_scorecard_type
    else
      case params[:scope].to_sym
      when :sdgs_alignment_cards then SustainableDevelopmentGoalAlignmentCard
      when :transition_cards then TransitionCard
      end
    end
  end
end
