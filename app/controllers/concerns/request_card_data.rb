module RequestCardData
  extend ActiveSupport::Concern

#   included do
#     before_action :load_request_card_data, only: [:index]
#   end

  def load_request_card_data
    @total_requests = Request.count
    @total_pending_requests = Request.where(is_selected: nil, user_id: nil).count # Not assigned, pending
    @total_assigned_requests = Request.where(is_selected: nil).where.not(user_id: nil).count # Assigned but not yet approved/rejected
    @total_approved_requests = Request.where(is_selected: true).count # Approved
    @total_rejected_requests = Request.where(is_selected: false).count # Rejected
    @total_in_progress_requests = Request.where.not(user_id: nil).count # Adjust based on actual column/logic
    @total_completed_requests = Request.where.not(is_selected: nil, user_id: nil).count # Adjust based on actual column/logic
  end

  def load_request_type_data
    @food_requests = Request.where(request_type: 'food_request').count
    @cash_requests = Request.where(request_type: 'cash_donation').count
    @cloth_requests = Request.where(request_type: 'cloth_donation').count
    @other_requests = Request.where.not(request_type: 'other_donation').count
  end

end