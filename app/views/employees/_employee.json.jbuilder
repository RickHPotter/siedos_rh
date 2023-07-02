json.extract! employee, :id, :full_name, :date_of_birth, :origin_city, :home_state, :marital_status, :sex, :workspace_id, :job_role_id, :created_at, :updated_at
json.url employee_url(employee, format: :json)
