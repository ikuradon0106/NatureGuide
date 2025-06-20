# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "seedの実行を開始"

# envファイルで定義した環境変数を指定
admin_email = ENV.fetch("ADMIN_EMAIL")
admin_password = ENV.fetch("ADMIN_PASSWORD")

# find_or_create_by!メソッドで、既存のデータがある場合はそのデータが取得されるのみで、登録処理が実行されないようにする
# 管理者用パスワード
Admin.find_or_create_by!(email: admin_email) do |admin|
  admin.password = admin_password
  admin.password_confirmation = admin_password
end

# envファイルで定義した環境変数を指定
user_email = ENV.fetch("TEST_USER_EMAIL")
user_password = ENV.fetch("TEST_USER_PASSWORD")

# テストユーザー（一般ユーザー）アカウント
User.find_or_create_by!(email: user_email) do |user|
  user.nickname = "テストユーザー"
  user.password = user_password
  user.password_confirmation = user_password
end

puts "seedの実行が終了しました"