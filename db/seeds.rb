# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "seedの実行を開始"

# find_or_create_by!メソッドで、既存のデータがある場合はそのデータが取得されるのみで、登録処理が実行されないようにする
# 管理者用パスワード
Admin.find_or_create_by!(email: "admin@example.com") do |admin|
  adimn.password = "password"
  admin.password_confirmation = "password"
end


# テストユーザー（一般ユーザー）アカウント
User.find_or_create_by!(email: "testuser@example.com") do |user|
  user.nickname = "テストユーザー"
  user.password = "natureguide"
  user.password_confirmation = "natureguide"
end

puts "seedの実行が終了しました"