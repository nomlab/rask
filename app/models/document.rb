# coding: utf-8
class Document < ApplicationRecord
  belongs_to :user, foreign_key: 'creator_id'
  belongs_to :creator, foreign_key: 'creator_id', class_name: 'User'
  belongs_to :project, optional: true
  has_many :document_tags, dependent: :destroy
  has_many :tags, through: :document_tags
  accepts_nested_attributes_for :document_tags, allow_destroy: true

  validates :start_at, presence: true
  validates :end_at, presence: true
  validates :location, presence: true
  #validates :project, presence: true
  before_validation :add_unique_action_item_marker

  def add_unique_action_item_marker
    desc = ""
    self.description.each_line {|line|
    matched = line.match(/-->\(([^!]+)\)/)
      if matched != nil
        @action_item = ActionItem.create(task_url: nil)
        line.gsub!(/-->\(.+\)/, "-->(#{matched[1]} !:#{@action_item.uid})")
      end
      desc += line
    }
    self.description = desc
  end

  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "creator_id", "description", "end_at", "id", "location", "project_id", "start_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["creator", "document_tags", "project", "tags", "user"]
  end
end
