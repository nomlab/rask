# coding: utf-8
namespace :create_user do
  desc "ユーザー名、パスワードを入力し、ユーザーアカウントを作成する"
  task :user, ['name','password'] => :environment do |_, args|
    User.create!(
      name:     args.name,
      password: args.password,
      provider: "local",
      uid: SecureRandom.hex(10),
      screen_name: args.name,
    )
    puts "#{args.name}を作成しました。"
  end
end

