module RequestCardData
  extend ActiveSupport::Concern

  # included do
  #   before_action :load_request_card_data, only: [:index]
  # end

  def load_request_card_data
    # Base query based on user role
    base_query = case current_user.role
                 when 'super_admin', 'admin'
                   Request.all
                 when 'branch_manager'
                   Request.where(branch_id: current_user.branch_id)
                 when 'volunteer'
                   Request.where(user_id: current_user.id, branch_id: current_user.branch_id)
                 else
                   Request.none # Fallback for unauthorized or guest users
                 end

    # Calculate counts based on the filtered base query
    @total_requests = base_query.count
    @total_pending_requests = base_query.where(is_selected: nil, user_id: nil).count # Not assigned, pending
    @total_assigned_requests = base_query.where(is_selected: nil).where.not(user_id: nil).count # Assigned but not yet approved/rejected
    @total_approved_requests = base_query.where(is_selected: true).count # Approved
    @total_rejected_requests = base_query.where(is_selected: false).count # Rejected
    @total_in_progress_requests = base_query.where.not(user_id: nil).count # Adjust based on actual column/logic
    @total_completed_requests = base_query.where.not(is_selected: nil, user_id: nil).count # Adjust based on actual column/logic
  end

  def load_request_type_data
    # Base query based on user role
    base_query = case current_user.role
                 when 'super_admin', 'admin'
                   Request.all
                 when 'branch_manager'
                   Request.where(branch_id: current_user.branch_id)
                 when 'volunteer'
                   Request.where(user_id: current_user.id, branch_id: current_user.branch_id)
                 else
                   Request.none # Fallback for unauthorized or guest users
                 end

    # Calculate request type counts based on the filtered base query
    @food_requests = base_query.where(request_type: 'food_request').count
    @cash_requests = base_query.where(request_type: 'cash_donation').count
    @cloth_requests = base_query.where(request_type: 'cloth_donation').count
    @other_requests = base_query.where(request_type: 'other_donation').count
  end
end