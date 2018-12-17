CarrierWave.configure do |config|
  config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => "AKIAIONO5S5OYPNKSCDQ",
      :aws_secret_access_key  => "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",
      :region                 => 'us-west-1' # Change this for different AWS region. Default is 'us-east-1'
  }
  config.fog_directory  = "picnotes"
end
