
CarrierWave.configure do |config|
  config.fog_credentials = {
    provider:              'AWS',                        # required
    aws_access_key_id:     Rails.application.credentials.dig(:aws, :aws_access_key_id),                        # required unless using use_iam_profile
    aws_secret_access_key: Rails.application.credentials.dig(:aws, :aws_secret_access_key),                        # required unless using use_iam_profile
    use_iam_profile:       false,                            # optional, defaults to false
    region:                Rails.application.credentials.dig(:aws, :AWS_REGION)                  # optional, defaults to 'us-east-1'
    # host:                  's3.example.com',             # optional, defaults to nil
    # endpoint:              'https://s3.example.com:8080' # optional, defaults to nil
  }
  config.fog_directory  = Rails.application.credentials.dig(:aws, :S3_BUCKET_NAME)                                      # required
  config.fog_public    = true
  config.cache_dir     = "#{Rails.root}/tmp/uploads"         # To let CarrierWave work on Heroku
  config.storage       = :fog
end
