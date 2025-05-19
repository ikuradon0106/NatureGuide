require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PF
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #

    # タイムゾーンを日本（東京）に変更
    config.time_zone = "Tokyo"

    # 国際化(i18n)を使って、enumの日本語化設定
    config.i18n.default_locale = :ja

    # config.eager_load_paths << Rails.root.join("extras")
  end
end
