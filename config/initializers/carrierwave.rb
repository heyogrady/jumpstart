require "carrierwave/orm/activerecord"

case Rails.env
when "test"
  CarrierWave.configure do |config|
    config.root = Rails.root.join("tmp")
    config.storage = :file
    config.enable_processing = false
  end
when "development"
  CarrierWave.configure do |config|
    config.permissions = 0600
    config.directory_permissions = 0700
    config.storage = :file
    config.cache_dir = Rails.root.join("tmp/uploads")
    config.asset_host = Settings.asset_host
  end
else
  CarrierWave.configure do |config|
    config.root = Rails.root.join("tmp")
    config.storage = :fog
    config.cache_dir = "carrierwave"
    config.fog_directory = Settings.aws_s3.bucket_name

    config.fog_credentials = {
      provider: "AWS",
      aws_access_key_id: Settings.aws_s3.access_key_id,
      aws_secret_access_key: Settings.aws_s3.secret_access_key,
    }

    config.fog_credentials[:region] = "us-west-1" if Rails.env.staging?
  end
end
