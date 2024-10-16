module ErrorHandler
  extend ActiveSupport::Concern

  def handle_destroy_error(error)
    case error
    when ActiveRecord::InvalidForeignKey, PG::ForeignKeyViolation
      "This record cannot be deleted as it's associated with other records. Please remove related records first."
    when ActiveRecord::RecordNotDestroyed
      "Failed to delete the record. Please try again later."
    when ActiveRecord::RecordInvalid
      "The record could not be deleted due to invalid data."
    when ActiveRecord::RecordNotFound
      "The record you are trying to delete does not exist."
    when ActiveRecord::Deadlocked
      "The record could not be deleted due to a database deadlock. Please try again."
    when ActiveRecord::StatementInvalid
      "An unexpected database error occurred. Please contact support."
    when PG::ConnectionBad
      "There was an issue connecting to the database. Please try again later."
    when Timeout::Error
      "The operation timed out. Please try again later."
    when SystemCallError
      "A system error occurred. Please check your server resources."
    when NoMethodError
      "An unexpected error occurred. Please contact support."
    else
      "An unexpected error occurred while trying to delete the record."
    end
  end
end
