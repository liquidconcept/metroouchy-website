module Application
  class ImageUploader < CarrierWave::Uploader::Base
    CarrierWave.configure do |config|
      config.fog_credentials = {
        :provider               => 'AWS',
        :aws_access_key_id      => 'AKIAJAVZXFHDEOH2VDSQ',
        :aws_secret_access_key  => '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',
        :region                 => 'eu-west-1'
      }
      config.fog_directory  = 'metroouchy'
      config.fog_public     = true
    end

    storage :fog

    def filename
      "#{model.class.name}/#{Sinatra::Base.environment}/#{model.id}.jpg"
    end
  end
end
