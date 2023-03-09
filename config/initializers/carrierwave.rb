
CarrierWave.configure do |config|
  config.fog_credentials = {
    provider:              'AWS',                        # required
    aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],                        # required unless using use_iam_profile
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],                        # required unless using use_iam_profile
    use_iam_profile:       true,                            # optional, defaults to false
    region:                ENV['AWS_REGION']                  # optional, defaults to 'us-east-1'
    # host:                  's3.example.com',             # optional, defaults to nil
    # endpoint:              'https://s3.example.com:8080' # optional, defaults to nil
  }
  config.fog_directory  = ENV['S3_BUCKET_NAME']                                      # required
  config.fog_public    = true
  config.cache_dir     = "#{Rails.root}/tmp/uploads"         # To let CarrierWave work on Heroku
  config.storage       = :fog
end
