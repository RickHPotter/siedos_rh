class CreateEmployees < ActiveRecord::Migration[5.1]
  def change
    create_table :employees do |t|
      t.string :full_name
      t.date :date_of_birth
      t.string :origin_city
      t.string :home_state
      t.string :marital_status
      t.string :sex
      t.references :workspace, foreign_key: true
      t.references :job_role, foreign_key: true

      t.timestamps
    end
  end
end
