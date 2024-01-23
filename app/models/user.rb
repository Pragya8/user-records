# app/models/user.rb

class User < ApplicationRecord
  after_commit :update_daily_record, on: [:create, :update]
  ransacker :name_or_age_or_gender_cont do
    Arel.sql("CONCAT_WS(' ', COALESCE(users.name->>'first', ''), COALESCE(users.name->>'last', ''), age, gender)")
  end

  def self.ransackable_attributes
    %w[name age gender]
  end

  def self.ransackable_associations
    []
  end

  def update_daily_record
    return unless saved_changes[:gender]

    daily_record = DailyRecord.find_or_create_by(date: Date.today)

    if saved_changes[:gender][0] == 'male'
      daily_record.male_count = [0, daily_record.male_count - 1].max
    elsif saved_changes[:gender][0] == 'female'
      daily_record.female_count = [0, daily_record.female_count - 1].max
    end

    if saved_changes[:gender][1] == 'male'
      daily_record.male_count += 1
    elsif saved_changes[:gender][1] == 'female'
      daily_record.female_count += 1
    end

    daily_record.save
  end

  def self.to_liquid_array(users)
    users.map do |user|
      {
        'id' => user.id,
        'name' => user.name,
        'age' => user.age,
        'location' => user.location,
        'gender' => user.gender,
        'created_at' => user.created_at
      }
    end
  end
end
