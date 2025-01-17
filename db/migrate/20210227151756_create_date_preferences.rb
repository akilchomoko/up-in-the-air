class CreateDatePreferences < ActiveRecord::Migration[6.0]
  def change
    create_table :date_preferences do |t|
      t.date :start_date
      t.date :end_date
      t.references :trip_participant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
