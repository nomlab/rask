ENV["RAILS_ENV"] ||= "test"

require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest

  # テストユーザーとしてログインする
  def log_in_as(user)
    OmniAuth.config.mock_auth[:github] =
      OmniAuth::AuthHash.new({
                               :provider => 'github',
                               :uid => user.id,
                               :credentials => {
                                 :token => 'mock_token',
                                 :active_member => 'mock_active_member'
                               },
                               :info => {
                                 :nickname => 'nickname',
                                 :name => 'name',
                                 :image => 'image'
                               }
                             })

    get '/auth/github/callback'
  end
end
