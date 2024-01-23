# app/models/daily_record.rb
class DailyRecord < ApplicationRecord
  include ActiveModel::Dirty

  before_save :calculate_avg_ages, if: -> { male_count_changed? || female_count_changed? }

  def calculate_avg_ages
    self.male_avg_age = calculate_avg_age('male')
    self.female_avg_age = calculate_avg_age('female')
  end

  def calculate_avg_age(gender)
    users = User.where(gender: gender)
    total_age = users.sum(:age)
    total_users = users.count
    total_users.positive? ? (total_age / total_users) : 0
  end

  def self.to_liquid_array(daily_records)
    daily_records.map do |record|
      {
        'date' => record.date,
        'male_count' => record.male_count,
        'female_count' => record.female_count,
        'male_avg_age' => record.male_avg_age,
        'female_avg_age' => record.female_avg_age
      }
    end
  end
end
