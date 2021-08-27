# coding: utf-8
class Task < ApplicationRecord
  belongs_to :user, foreign_key: 'creator_id'
  belongs_to :assigner, foreign_key: 'assigner_id', class_name: 'User'
  belongs_to :project, optional: true
  belongs_to :state, foreign_key: 'status'

  def show_days_ago
    day = ((self.created_at - Time.zone.now)/60/60/24).abs.round.to_s
    day + "日前"
  end
end
