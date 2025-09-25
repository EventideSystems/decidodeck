# frozen_string_literal: true

require 'csv'

# Controller for managing impact card data models
class DataModelsController < ApplicationController # rubocop:disable Metrics/ClassLength
  after_action :verify_authorized, except: :index

  sidebar_item :library

  def index # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    search_params = params.permit(:format, :page, q: [:name_or_description_cont])

    base_scope = build_base_scope
    @q = base_scope.order(:name).ransack(search_params[:q])

    data_models = @q.result(distinct: true)

    @pagy, @data_models = pagy(data_models, limit: 10)
    @all_data_models = policy_scope(DataModel).order('lower(name)')

    respond_to do |format|
      format.html do
        render 'data_models/index', locals: { data_models: @data_models }
      end
      format.turbo_stream do
        render 'data_models/index', locals: { data_models: @data_models }
      end

      format.css do
        render 'data_models/index', formats: [:css],
                                    locals: { data_models: @data_models }
      end

      # format.csv do
      #   csv_data = CSV.generate(headers: true) do |csv|
      #     csv << ['Name', 'Short Name', 'Description', 'Author', 'License', 'Status', 'Public Model', 'Created At',
      #             'Updated At', 'Workspace']
      #     @all_data_models.each do |data_model|
      #       csv << [data_model.name, data_model.short_name, data_model.description, data_model.author,
      #               data_model.license, data_model.status, data_model.public_model ? 'Yes' : 'No',
      #               data_model.created_at, data_model.updated_at,
      #               data_model.workspace.name]
      #     end
      #   end
      #   send_data csv_data, filename: "data_models-#{Time.zone.now.strftime('%Y%m%d%H%M%S')}.csv"
      # end
    end
  end

  def show
    @data_model = policy_scope(DataModel).find(params[:id])
    authorize @data_model
  end

  def new
    @data_model = current_workspace.data_models.build(author: current_user.display_name, status: :draft)
    authorize @data_model
  end

  def create
    @data_model = build_data_model

    authorize @data_model
    if @data_model.save
      redirect_to edit_data_model_path(@data_model), notice: 'Data Model was successfully created.'
    else
      render :new
    end
  end

  def copy_to_current_workspace
    @data_model = policy_scope(DataModel).find(params[:id])
    authorize @data_model

    new_data_model = DataModels::CopyToWorkspace.call(
      data_model: @data_model, workspace: current_workspace
    )

    redirect_to data_model_path(new_data_model),
                notice: 'Data Model copied to current workspace'
  end

  def edit
    @data_model = policy_scope(DataModel).find(params[:id])
    authorize @data_model
  end

  def edit_name
    @data_model = policy_scope(DataModel).find(params[:id])
    authorize @data_model, :edit?
  end

  def update_name
    @data_model = policy_scope(DataModel).find(params[:id])
    authorize @data_model, :edit?
    @data_model.assign_attributes(data_model_params)

    if @data_model.save
      respond_to do |format|
        format.turbo_stream
      end
    else
      render 'edit_name'
    end
  end

  def edit_description
    @data_model = policy_scope(DataModel).find(params[:id])
    authorize @data_model, :edit?
  end

  def update_description
    @data_model = policy_scope(DataModel).find(params[:id])
    authorize @data_model, :edit?
    @data_model.assign_attributes(data_model_params)

    if @data_model.save
      respond_to do |format|
        format.turbo_stream
      end
    else
      render 'edit_description'
    end
  end

  def update
    @data_model = policy_scope(DataModel).find(params[:id])
    authorize @data_model
    @data_model.assign_attributes(data_model_params)
  end

  private

  def build_base_scope # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    filter_params = params.permit(q: %i[current_workspace other_workspaces public_models])

    other_workspaces = current_user.workspaces.where.not(id: current_workspace.id)

    permitted_workspaces = if filter_params.empty? || filter_params.dig(:q, :current_workspace) == '1'
                             [current_workspace]
                           else
                             []
                           end

    permitted_workspaces.concat(other_workspaces) if filter_params.dig(:q, :other_workspaces) == '1'

    base_scope = policy_scope(DataModel)

    base_scope = base_scope.where(workspace: permitted_workspaces)
    if filter_params.dig(:q, :public_models) == '1'
      base_scope.or(DataModel.where(public_model: true))
    else
      base_scope.where(public_model: [false, nil])
    end
  end

  def build_data_model # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    if params[:data_model][:public_model] && policy(DataModel).make_public_model?
      DataModel.new(data_model_params)
    else
      current_workspace.data_models.build(data_model_params)
    end.tap do |data_model|
      data_model.focus_area_groups.build(name: 'First Goal', position: 1).tap do |group|
        group.focus_areas.build(name: 'First Target', position: 1).tap do |area|
          area.characteristics.build(name: 'First Indicator', position: 1)
          area.characteristics.build(name: 'Second Indicator', position: 2)
        end
      end
    end
  end

  def data_model_params
    params[:data_model].delete(:public_model) unless policy(DataModel).make_public_model?
    params.require(:data_model).permit(:name, :short_name, :description, :author, :license, :color, :status,
                                       :public_model)
  end
end
