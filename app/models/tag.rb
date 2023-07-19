class Tag < ApplicationRecord
  has_many :task_tags, dependent: :destroy
  has_many :tasks, through: :task_tags, dependent: :restrict_with_exception
  has_many :document_tags, dependent: :destroy
  has_many :documents, through: :document_tags, dependent: :restrict_with_exception
  validates :name, presence: true, uniqueness: true
end
