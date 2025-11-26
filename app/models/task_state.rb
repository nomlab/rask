class TaskState < ApplicationRecord
  has_many :tasks, dependent: :restrict_with_exception

  validates :name, presence: true
  validates :priority, presence: true

  def self.ransackable_attributes(auth_object = nil)
    [ "priority" ]
  end

  def self.todo
    @todo ||= find_by(name: 'todo')
  end

  def self.done
    @done ||= find_by(name: 'done')
  end

  def self.draft
    @draft ||= find_by(name: 'draft')
  end
end
