# coding: utf-8
class Document < ApplicationRecord
  belongs_to :user, foreign_key: 'creator_id'
  belongs_to :assigner, foreign_key: 'assigner_id', class_name: 'User'
  belongs_to :project, optional: true

  validates :start_at, presence: true
  validates :end_at, presence: true
  validates :location, presence: true
  #validates :project, presence: true
  # Replace action-item number into corresponding GitHub issue number.
  # Example:
  #   "-->(name !:0001)" becomes "-->(name nomlab/jay/#10)"
  def self.cooked_content(description)
    new_description = ""
    description.split("\n").map do |line|
      line.gsub(/-->\((.+?)!:([0-9]{4})\)/) do |match|
        assignee, action = $1.strip, $2
        issue = ActionItem.find_by_id(action.to_i).try(:github_issue)
        issue ? "-->(#{assignee} #{issue}{:data-action-item=\"#{action}\"})" :
          "-->(#{assignee} !:#{action})"
        line = line.gsub(/-->\((.+?)(?:!:([0-9]{4}))?\)/,  "-->(#{assignee} !:#{issue}{:data-action-item=\"#{action}\"})")
      end
      new_description += line
      new_description += "\n"
    end
    return new_description
  end

  # Add action-item number with prefix "!:".
  # Example:
  #   "-->(name)" becomes "-->(name !:0001)"
  def self.add_unique_action_item_marker(content)
    new_description = ""
    description = content.split("\n").map do |line|
      line.gsub(/-->\((.+?)(?:!:([0-9]{4}))?\)/) do |match|
        assignee, action = $1.strip, $2
        action = ActionItem.create.uid unless action
        "-->(#{assignee} !:#{action})"
        line = line.gsub(/-->\((.+?)(?:!:([0-9]{4}))?\)/,  "-->(#{assignee} !:#{action})")
      end
      new_description += line
      new_description += "\n"
    end
    return new_description
  end
end
