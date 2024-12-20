json.extract! patient, :id, :name, :email, :date_of_birth, :next_appointment, :created_at, :updated_at
json.url patient_url(patient, format: :json)
