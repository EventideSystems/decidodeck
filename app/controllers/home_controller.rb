# frozen_string_literal: true

# Controller for the home page
class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :check_accepted_terms, except: [:index]

  layout :determine_layout

  menu_item :workspace

  def index
    if user_signed_in?
      load_records
      load_index_breadcrumbs
      render_workspace
    else
      render 'home/landing'
    end
  end

  def new_artifact
    add_breadcrumb 'Artifacts', root_path
    add_breadcrumb 'Add Artifact'
    load_records
  end

  private

  def determine_layout
    user_signed_in? ? 'application' : 'landing'
  end

  # Perform a search and load records for the dashboard
  def load_records
    base_query = policy_scope(Artifact).order(updated_at: :desc)
    @q = base_query.ransack(search_params[:q])
    @artifacts = @q.result(distinct: true)

    @artifact_types = Artifact.distinct.pluck(:artifact_type).sort
    @selected_artifact_types = params[:artifact_types] || @artifact_types
    @available_workspaces = current_user.available_workspaces
  end

  def load_index_breadcrumbs
    breadcrumbs.clear

    if @available_workspaces.count > 1 || !current_workspace.in?(@available_workspaces)
      add_breadcrumb workspace_switcher_html
    else
      add_breadcrumb(workspace_home_html, workspace_path(current_workspace), title: 'Home')
    end

    add_breadcrumb 'Artifacts'
  end

  def render_workspace
    respond_to do |format|
      format.html do
        render 'home/index', locals: { artifacts: @artifacts }
      end
      format.turbo_stream do
        render 'home/index', locals: { artifacts: @artifacts }
      end
    end
  end

  def search_params
    params.permit(:format, :page, q: [:name_or_description_cont, { artifact_type_in: [] }])
  end

  def workspace_home_html
    self.class.home_icon +
      " <span class='ml-2'>#{current_workspace.name}</span>".html_safe # rubocop:disable Rails/OutputSafety
  end

  def workspace_switcher_html
    render_to_string(
      partial: 'workspace_switcher',
      locals: { available_workspaces: @available_workspaces }
    ).html_safe # rubocop:disable Rails/OutputSafety
  end
end
