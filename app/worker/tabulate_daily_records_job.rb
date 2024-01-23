# app/jobs/tabulate_daily_records_job.rb
class TabulateDailyRecordsJob
  include Sidekiq::Worker

  def perform
    date_today = Date.current
    daily_record = DailyRecord.find_by(date: date_today)

    return if daily_record

    male_count = Redis.current.get('male_count').to_i
    female_count = Redis.current.get('female_count').to_i

    daily_record = DailyRecord.create!(
      date: date_today,
      male_count: male_count,
      female_count: female_count,
      male_avg_age: calculate_avg_age('male'),
      female_avg_age: calculate_avg_age('female')
    )

    update_user_counts_on_delete
    update_avg_ages_on_delete(daily_record)
  end

  private

  def calculate_avg_age(gender)
    users = User.where(gender: gender)
    total_age = users.sum(:age)
    total_users = users.count
    total_users.positive? ? (total_age / total_users) : 0
  end

  def update_user_counts_on_delete
    User.after_destroy do
      if destroyed?
        gender = gender_was
        Redis.current.decr('male_count') if gender == 'male'
        Redis.current.decr('female_count') if gender == 'female'
      end
    end
  end

  def update_avg_ages_on_delete(daily_record)
    User.after_destroy do
      if destroyed?
        gender = gender_was
        avg_age = calculate_avg_age(gender)
        daily_record.update!(
          male_avg_age: calculate_avg_age('male'),
          female_avg_age: calculate_avg_age('female')
        )
      end
    end
  end
end
