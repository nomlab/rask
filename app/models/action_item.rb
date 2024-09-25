class ActionItem < ApplicationRecord
  after_create :set_uid
  validates :task_url, format: { with: /\A[a-zA-Z0-9\-._~:\/?#\[\]@!$&'()*+,;%=]+\z/}, allow_nil: true
  validates :uid, uniqueness: true
  before_update :prevent_uid_change

  def uid
    "%04d" % self.id
  end

  private

  def set_uid
    self.update(uid: uid)
  end

  def prevent_uid_change
    if self.uid_was.present? && self.uid_changed?
      throw(:abort)
    end
  end

end
