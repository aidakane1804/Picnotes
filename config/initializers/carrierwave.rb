CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'] || 'AKIAI3RF62FGTORT3DMA',
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'] || '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',
    region: 'us-west-1'
  }
  config.fog_directory  = "picnotes-2019"
end
