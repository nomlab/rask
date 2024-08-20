class ActionItem < ApplicationRecord
  before_create :check_varid_id
  before_create :set_uid
  validates :task_url, format: { with: /\A[a-zA-Z0-9\-._~:\/?#\[\]@!$&'()*+,;%=]+\z/}, allow_nil: true
  validates :uid, uniqueness: true
  before_update :check_uid_readonly

  def uid
    "%04d" % self.id
  end

  private

  def check_varid_id
    if self.id > 9999 || self.id < 1 
      throw(:abort)
    end
  end

  def set_uid
    self.uid = uid
  end

  def check_uid_readonly
    if uid_changed?
      throw(:abort)
    end
  end
end
