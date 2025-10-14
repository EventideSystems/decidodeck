# frozen_string_literal: true

# Base controller for the application
class ApplicationController < ActionController::Base # rubocop:disable Metrics/ClassLength
  include Pundit::Authorization
  include ActiveSidebarItem
  include ActiveMenuItem
  include Pagy::Backend

  before_action :set_session_workspace_id
  before_action :authenticate_user!
  before_action :set_paper_trail_whodunnit
  before_action :set_actionmailer_host
  before_action :check_accepted_terms, if: :user_signed_in?
  before_action :set_i18n

  # protect_from_forgery with: :exception
  protect_from_forgery prepend: true

  impersonates :user

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :flash_resource_not_found

  sidebar_item :home

  class << self
    def home_icon
      <<~SVG.html_safe # rubocop:disable Rails/OutputSafety
        <svg viewBox="0 0 20 20" fill="currentColor" data-slot="icon" aria-hidden="true" class="size-5 shrink-0 w-6 h-6">
          <path d="M9.293 2.293a1 1 0 0 1 1.414 0l7 7A1 1 0 0 1 17 11h-1v6a1 1 0 0 1-1 1h-2a1 1 0 0 1-1-1v-3a1 1 0 0 0-1-1H9a1 1 0 0 0-1 1v3a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1v-6H3a1 1 0 0 1-.707-1.707l7-7Z" clip-rule="evenodd" fill-rule="evenodd" />
        </svg>
      SVG
    end
  end

  add_breadcrumb home_icon, '/'

  def current_account
    current_workspace&.account
  end

  helper_method :current_account

  def current_theme # rubocop:disable Metrics/MethodLength
    target_source = params[:theme] || request.host

    case target_source
    when /free[-|_]?sdg/
      :free_sdg
    when /obsekio/
      :obsekio
    when /tool[-|_]?for[-|_]?systemic[-|_]?change/
      :tool_for_systemic_change
    else
      :decidodeck
    end
  end

  helper_method :current_theme

  def current_theme_display_name
    case current_theme
    when :free_sdg
      'Free SDG'
    when :obsekio
      'Obsekio'
    when :tool_for_systemic_change
      'Tool for Systemic Change'
    else
      'Decidodeck'
    end
  end

  helper_method :current_theme_display_name

  def current_workspace
    return nil if current_user.blank?

    @current_workspace ||= fetch_workspace_from_session || fetch_default_workspace_and_set_session
  end

  helper_method :current_workspace

  def current_workspace=(workspace)
    @current_workspace = nil
    session[:workspace_id] = workspace.present? ? workspace.id : nil
    current_workspace
  end

  def pundit_user
    UserContext.new(current_user, current_workspace)
  end

  def require_workspace_selected
    return if current_workspace.present?

    redirect_back(fallback_location: dashboard_path, alert: 'Select an workspace before using this feature')
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :invite,
      keys: [
        :email,
        :name,
        :system_role,
        { workspace_members_attributes: %i[workspace_id workspace_role] }
      ]
    )
  end

  def info_for_paper_trail
    { workspace_id: current_workspace&.id }
  end

  def user_for_paper_trail
    true_user&.id
  end

  protected

  def sort_order
    return { name: :asc } if params[:order].blank?

    sort_mode = params[:sort_mode].blank? ? :asc : params[:sort_mode].to_sym
    { params[:order].to_sym => sort_mode }
  end

  private

  def check_accepted_terms
    return if current_user.accepted_terms?
    return if current_user.admin?
    return if current_user != true_user # Prevents issues when admin is impersonating another user

    redirect_to new_users_accept_terms_path
  end

  def fetch_workspace_from_session
    return nil if session[:workspace_id].blank?

    WorkspacePolicy::Scope
      .new(UserContext.new(current_user, nil), Workspace)
      .resolve
      .find_by(id: session[:workspace_id])
      .presence
  end

  def fetch_default_workspace_and_set_session
    default_workspace = current_user&.default_workspace
    default_workspace = Workspace.active.first if default_workspace.blank? && current_user.system_role == 'admin'
    session[:workspace_id] = default_workspace&.id
    default_workspace
  end

  def set_actionmailer_host
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  def set_session_workspace_id
    return unless session[:workspace_id].blank? && user_signed_in?

    self.current_workspace = current_user.default_workspace
  end

  def user_not_authorized(_exception)
    flash[:error] = 'Access denied.'
    # TODO: Would be nicer to have specific error messages, but for now just use "Access denied."
    # flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
    redirect_to(root_path)
  end

  def flash_resource_not_found(_exception)
    flash[:error] = "Resource not found in workspace '#{current_workspace.name}'"
    redirect_to(root_path)
  end

  def set_i18n # rubocop:disable Metrics/AbcSize
    I18n.locale = current_account&.default_locale.presence || I18n.default_locale

    return if I18n::Backend::ActiveRecord.config.scope == current_account&.i18n_scope.presence

    I18n::Backend::ActiveRecord.config.scope = current_account&.i18n_scope.presence
    I18n.backend.reload!
  end
end
