CarrierWave.configure do |config|
  settings = YAML.load_file(File.expand_path('../../config/settings.yml', __FILE__)) rescue {}

  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => settings['aws']['access_key_id'],
    :aws_secret_access_key  => settings['aws']['secret_access_key'],
    :region                 => settings['aws']['region']
  }
  config.fog_directory  = settings['aws']['bucket']
  config.fog_public     = true
end
