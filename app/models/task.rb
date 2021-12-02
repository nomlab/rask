# coding: utf-8
class Task < ApplicationRecord
  belongs_to :user, foreign_key: 'creator_id'
  belongs_to :assigner, foreign_key: 'assigner_id', class_name: 'User'
  belongs_to :project, optional: true
  has_many :task_tags, dependent: :destroy
  has_many :tags, through: :task_tags
  accepts_nested_attributes_for :task_tags, allow_destroy: true
  belongs_to :state, foreign_key: 'task_state_id', class_name: 'TaskState'

  def show_days_ago
    day = ((self.created_at - Time.zone.now)/60/60/24).abs.round.to_s
    day + "日前"
  end

  def completed?
    self.state.name == "done"
  end

end
