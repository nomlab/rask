class User < ApplicationRecord
    has_secure_password validations: false

    # github action uses the provider name "github"
    validate do |record|
      if (record.password_digest.blank? && record.provider != "github") then
        record.errors.add(attribute, :blank)
      end
    end
    validates_length_of :password, maximum: ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED
    validates_confirmation_of :password, allow_blank: true

    has_many :tasks, foreign_key: 'creator_id'
    has_many :projects
    has_many :api_tokens, foreign_key: 'user_id'
    has_many :documents, foreign_key: 'creator_id'
    validates :screen_name, uniqueness: true

    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                 BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    def self.create_with_omniauth(auth)
        create! do |user|
            user.provider = auth["provider"]
            user.uid      = auth["uid"]

            info = auth["info"]
            user.name        = info["name"] || info["nickname"]
            user.screen_name = info["nickname"]
            user.avatar_url  = info["image"]
        end
    end

    def self.ransackable_attributes(auth_object = nil)
      ["active", "avatar_url", "created_at", "id", "name", "password_digest", "provider", "screen_name", "uid", "updated_at"]
    end
end
