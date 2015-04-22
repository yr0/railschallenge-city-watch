class CreateEmergencies < ActiveRecord::Migration
  def change
    create_table :emergencies do |t|
      t.string :code, null: false
      t.string :state
      t.integer :fire_severity
      t.integer :medical_severity
      t.integer :police_severity
      t.boolean :full_response, default: false
      t.datetime :resolved_at

      t.timestamps null: false
    end
    add_index :emergencies, :code, unique: true
  end
end
