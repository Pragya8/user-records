# app/jobs/fetch_users_records_job.rb
require 'rest-client'

class FetchUserRecordsJob
  include Sidekiq::Worker

  def perform
    users_data.each do |user_data|
      user = User.find_or_initialize_by(uuid: user_data['login']['uuid'])
      user.assign_attributes(
        name: "#{user_data['name']['first']} #{user_data['name']['last']}",
        age: user_data['dob']['age'],
        gender: user_data['gender'],
        location: user_data['location']
      )
      user.save
    end

    update_gender_counts(users_data)
  end

  def users_data
    url = 'https://randomuser.me/api/?results=20'
    headers = {
      content_type: 'application/json'
    }
    response = RestClient::Request.execute(
      url: url,
      method: :get,
      headers: headers,
      verify_ssl: false
    )
    JSON.parse(response.body)['results']
  end

  private

  def update_gender_counts(users_data)
    male_count = users_data.count { |user| user['gender'] == 'male' }
    female_count = users_data.count { |user| user['gender'] == 'female' }

    Redis.current.multi do
      Redis.current.incrby('male_count', male_count)
      Redis.current.incrby('female_count', female_count)
    end
  end
end
