module Application
  require 'digest/sha1'

  class ImageUploader < CarrierWave::Uploader::Base
    CarrierWave.configure do |config|
      config.fog_credentials = {
        :provider               => 'AWS',
        :aws_access_key_id      => @@config['aws']['access_key_id'],
        :aws_secret_access_key  => @@config['aws']['secret_access_key'],
        :region                 => @@config['aws']['region']
      }
      config.fog_directory  = @@config['aws']['bucket']
      config.fog_public     = true
    end

    storage :fog

    def path_or_url
      return path if File.exists?(path)
      url
    end

    def filename
      @name ||= "#{model.class.name.split('::').last.downcase.pluralize}/#{Sinatra::Base.environment}/#{model.id}-#{checksum}#{File.extname(super)}" if super
    end

    def checksum
      chunk = model.send(mounted_as)
      @checksum ||= Digest::SHA1.hexdigest(File.open(path_or_url).read)
    end
  end
end
