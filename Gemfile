source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem "rails", "~> 6.1.7", ">= 6.1.7.10"
# Use sqlite3 as the database for Active Record
gem "sqlite3", "~> 1.4"
# Use Puma as the app server
gem "puma", "~> 3.11"
# Use SCSS for stylesheets
gem "sass-rails", ">= 6"
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker", "~> 5.0"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'


# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.4", require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]

  gem 'pry-byebug'
  gem 'pry-rails'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", ">= 4.1.0"
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem "rack-mini-profiler", "~> 2.0"
  gem "listen", "~> 3.3"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring", "4.2.1"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 3.26"
  gem "selenium-webdriver", ">= 4.0.0.rc1"
  # Easy installation and use of web drivers to run system tests with browsers
  gem "webdrivers"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem "devise"

gem "dotenv-rails"
group :production do
  gem "mysql2"
end

gem "net-smtp"
gem "net-pop"
gem "net-imap"

gem "enum_help"
gem "geocoder"

# GBIFの Ruby 向けの非公式 API クライアント
gem "gbifrb"

# HTTP通信を助けるツール（ライブラリ）→これを導入しないとgbifrbが動かない
# GBIFという生き物の情報をまとめているサービスからデータをもらうとき、Faradayが橋渡し役となる
gem "faraday"

# JSONのパース・生成を抽象化するライブラリ
gem "multi_json"

# Active Storage の variant（画像のリサイズやトリミングなどの処理）機能を使うための中核ライブラリ。
gem "image_processing"
# 実際の画像処理（リサイズやフォーマット変換など）を担当するライブラリ。
# image_processing から呼び出されて動作する。ImageMagick を内部で使用。
gem "mini_magick", "~> 4.8"

# ページネーションに必要な機能を効率的に提供するGem
gem "kaminari", "~> 1.2.1"

# 静的コード解析ツール(Rubocop)
gem "rubocop", require: false
gem "rubocop-performance", require: false
gem "rubocop-rails", require: false
gem "rubocop-minitest", require: false
gem "rubocop-packaging", require: false
gem "rubocop-rspec"
gem "rubocop-md"

