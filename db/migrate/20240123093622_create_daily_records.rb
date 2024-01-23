class CreateDailyRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :daily_records do |t|
      t.date :date
      t.integer :male_count, default: 0
      t.integer :female_count, default: 0
      t.float :male_avg_age
      t.float :female_avg_age

      t.timestamps
    end
  end
end
