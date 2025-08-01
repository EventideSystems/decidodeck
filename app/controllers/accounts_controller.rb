# frozen_string_literal: true

# Controller for Accounts
class AccountsController < ApplicationController
  include VerifyPolicies

  before_action :set_account, only: %i[show edit update destroy switch]

  def index
    search_params = params.permit(:format, :page, q: [:name_or_description_cont])

    @q = policy_scope(Account).order(:name).ransack(search_params[:q])

    accounts = @q.result(distinct: true)

    @pagy, @accounts = pagy(accounts, limit: 10)

    respond_to do |format|
      format.html { render 'accounts/index', locals: { accounts: @accounts } }
      format.turbo_stream { render 'accounts/index', locals: { accounts: @accounts } }
    end
  end

  def show
    @account.readonly!
    render 'show'
  end

  def new
    @account = Account.new(expires_on: Time.zone.today + 1.year)
    authorize(@account)
  end

  def edit; end

  def create
    @account = Account.new(account_params)
    authorize(@account)

    if @account.save
      redirect_to(edit_account_path(@account), notice: 'Account was successfully created.')
    else
      render(:new)
    end
  end

  def update
    if @account.update(account_params)
      redirect_to(account_path(@account), notice: 'Account was successfully updated.')
    else
      render(:edit)
    end
  end

  def destroy
    @account.destroy
    redirect_to(accounts_url, notice: 'Account was successfully deleted.')
  end

  def switch
    self.current_account = @account
    redirect_to(dashboard_path, notice: 'Account successfully switched.')
  end

  def content_subtitle
    @account&.name.presence || super
  end

  private

  def set_account
    @account = Account.find(params[:id])
    authorize(@account)
  end

  def account_params
    params.fetch(:account, {}).permit(
      :name,
      :description,
      :classic_grid_mode,
      :deactivated,
      :expires_on,
      :max_users,
      :max_scorecards
    )
  end
end
