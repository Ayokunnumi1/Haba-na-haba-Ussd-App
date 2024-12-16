class RequestsController < ApplicationController
  load_and_authorize_resource
  include EnglishMenu

  before_action :set_request, only: %i[show edit update destroy]
  skip_before_action :verify_authenticity_token, only: [:ussd]

  def index
    @districts = District.all
    @counties = County.none
    @sub_counties = SubCounty.none
    @requests = Request.apply_filters(params).order(created_at: :desc)
    @requests = @requests.where(event_id: nil) if params.except(:controller, :action).empty?
    # Restrict to branch_manager's branch
    @requests = @requests.where(branch_id: current_user.branch_id) if current_user.role == 'branch_manager'
  end

  def ussd
    phone_number = params[:phoneNumber]
    text = params[:text]

    @request = Request.all

    response = process_ussd(text, phone_number)
    render plain: response
  end

  def show
    return unless params[:notification_id].present?

    notification = current_user.notifications.find_by(id: params[:notification_id])
    return unless notification.present? && !notification.read

    notification.update(read: true)
    Rails.logger.info "Notification #{notification.id} marked as read"
  end

  def new
    @request = Request.new
    @branches = Branch.all
    @districts = District.all
    @counties = County.none
    @users = User.where(role: 'volunteer')
    @sub_counties = SubCounty.none
  end

  def edit
    @request = Request.find(params[:id])
    @event = Event.find_by(id: params[:event_id])
    @districts = District.all
    @branches = @request.district.present? ? Branch.joins(:branch_districts).where(branch_districts: { district_id: @request.district_id }) : Branch.none
    @counties = @request.district.present? ? County.where(district_id: @request.district_id) : County.none
    @sub_counties = @request.county.present? ? SubCounty.where(county_id: @request.county_id) : SubCounty.none
    @users = User.where(role: 'volunteer')
  end

  def create
    @request = Request.new(request_params)
    # Restrict branch_id for branch_manager
    @request.branch_id = current_user.branch_id if current_user.role == 'branch_manager'

    if @request.save
      notify_branch_managers(@request, current_user)
      redirect_to @request, notice: 'Request was successfully created.'
    else
      @districts = District.all
      @branches = @request.district.present? ? Branch.joins(:branch_districts).where(branch_districts: { district_id: @request.district_id }) : Branch.none
      @counties = @request.district.present? ? County.where(district_id: @request.district_id) : County.none
      @sub_counties = @request.county.present? ? SubCounty.where(county_id: @request.county_id) : SubCounty.none
      render :new, alert: 'Failed to create request.' # render :new instead of render :edit
    end
  end

  def update
    # Prevent branch_manager from updating requests outside their branch
    unless @request.branch_id == current_user.branch_id || current_user.admin? || current_user.super_admin?
      redirect_to requests_path, alert: 'You are not authorized to update this request.' and return
    end

    if @request.update(request_params)
      notify_branch_managers(@request, current_user)
      notify_request_user(@request, current_user)
      redirect_to @request, notice: 'Request was successfully updated.'
    else
      @districts = District.all
      @branches = @request.district.present? ? Branch.joins(:branch_districts).where(branch_districts: { district_id: @request.district_id }) : Branch.none
      @counties = @request.district.present? ? County.where(district_id: @request.district_id) : County.none
      @sub_counties = @request.county.present? ? SubCounty.where(county_id: @request.county_id) : SubCounty.none
      render :edit, alert: 'Failed to update request.'
    end
  end

  def destroy
    # Prevent branch_manager from deleting requests
    unless @request.branch_id == current_user.branch_id || current_user.admin? || current_user.super_admin?
      redirect_to requests_path, alert: 'You are not authorized to delete this request.' and return
    end

    if @request.destroy
      redirect_to requests_url, notice: 'Request was successfully destroyed.'
    else
      redirect_to requests_url, alert: 'Failed to delete request.'
    end
  end

  def load_counties
    @counties = if params[:district_id].present?
                  County.where(district_id: params[:district_id])
                else
                  County.none
                end
    render json: @counties.map { |county| { id: county.id, name: county.name } }
  end

  def load_branches
    if params[:district_id].present?
      branches = Branch.joins(:branch_districts)
        .where(branch_districts: { district_id: params[:district_id] })
      render json: branches.map { |branch| { id: branch.id, name: branch.name } }
    else
      render json: { error: 'District ID is required' }, status: :bad_request
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def load_sub_counties
    @sub_counties = if params[:county_id].present?
                      SubCounty.where(county_id: params[:county_id])
                    else
                      SubCounty.none
                    end
    render json: @sub_counties.map { |sub_county| { id: sub_county.id, name: sub_county.name } }
  end

  def create_for_event
    @event = Event.find(params[:event_id])
    @request = @event.requests.new(request_params)

    if @request.save
      redirect_to event_path(@event), notice: 'Request created successfully!'
    else
      render :new
    end
  end
  rescue_from CanCan::AccessDenied do |_|
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to requests_path
  end

  private

  def process_ussd(text, phone_number)
    EnglishMenu.process_menu(text, phone_number, session)
  end

  def set_request
    @request = Request.find(params[:id])
  end

  def request_params
    params.require(:request).permit(:name, :phone_number, :request_type,
                                    :residence_address, :is_selected, :district_id,
                                    :county_id, :sub_county_id,
                                    :branch_id, :user_id, :event_id)
  end

  def notify_branch_managers(request, current_user)
    branch_managers = User.where(role: 'branch_manager', branch_id: request.branch_id)
      .where.not(id: current_user.id)

    branch_managers.each do |manager|
      Notification.create(
        user: manager,
        notifiable: request,
        message: 'A new request has been created in your branch.'
      )
    end
  end

  def notify_request_user(request, current_user)
    return if request.user_id.nil? || request.user_id == current_user.id

    user = User.find(request.user_id)

    Notification.create(
      user: user,
      notifiable: request,
      message: 'You are assigned to a new request.'
    )
  end
end
