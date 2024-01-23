class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @users = User.all
    @total_users = User.count
    if params[:q] && params[:q][:name_or_age_or_gender_cont].present?
      search_query = params[:q][:name_or_age_or_gender_cont]
      @users = @users.where('users.name::text ILIKE ?', "%#{search_query}%")
                     .or(@users.where('users.age::text ILIKE ?', "%#{search_query}%"))
                     .or(@users.where('users.gender::text ILIKE ?', "%#{search_query}%"))

    end
    @users = User.to_liquid_array(@users)
  end

  def destroy
    user = User.find(params[:id])
    user.destroy

    update_daily_record_counts(user.gender)
    redirect_to users_path
  end

  private

  def update_daily_record_counts(gender)
    daily_record = DailyRecord.find_or_create_by(date: Date.today)

    case gender
    when 'male'
      daily_record.male_count -= 1
    when 'female'
      daily_record.female_count -= 1
    end

    daily_record.save
  end
end
