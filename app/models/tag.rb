class Tag < ApplicationRecord
  has_many :task_tags
  has_many :tasks, through: :task_tags, dependent: :restrict_with_exception
  has_many :document_tags
  has_many :documents, through: :document_tags, dependent: :restrict_with_exception
  validates :name, presence: true, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    [ "id", "name" ]
  end

  def self.order_by_popularity
    self.find_by_sql <<~'SQL'
      SELECT
        tags.*,
        count(DISTINCT document_tags.id) + count(DISTINCT task_tags.id) AS popularity
      FROM
        tags
        LEFT JOIN document_tags ON tags.id = document_tags.tag_id
        LEFT JOIN task_tags ON tags.id = task_tags.tag_id
      GROUP BY
        tags.id
      ORDER BY
        popularity DESC
      ;
    SQL
  end
end
