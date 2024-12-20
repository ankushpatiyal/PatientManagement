class Patient < ApplicationRecord
  # constant
  UPCOMING_APPOINTMENT_TIME = 72.hours

  # Validations
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "invalid email format" }
  validates :date_of_birth, presence: true, format: { with: /\A\d{4}-\d{2}-\d{2}\z/, message: "must be in the format YYYY-MM-DD" }

  # Scope
  scope :fetch_upcoming_patients, -> { where(next_appointment: DateTime.now..(DateTime.now+UPCOMING_APPOINTMENT_TIME)) }

  def self.filter_by_name_email_or_all(value = "")
    return Patient.all if value.blank?

    sanitized_value = "%#{Patient.sanitize_sql_like(value)}%"
    where("name LIKE ? or email LIKE ?", sanitized_value, sanitized_value)
  end
end
