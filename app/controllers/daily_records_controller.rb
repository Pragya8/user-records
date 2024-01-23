class DailyRecordsController < ApplicationController
  def report
    @daily_records = DailyRecord.to_liquid_array(DailyRecord.all)
  end
end
