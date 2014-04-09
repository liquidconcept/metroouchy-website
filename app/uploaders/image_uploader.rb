module Application
  require 'digest/sha1'

  class ImageUploader < CarrierWave::Uploader::Base
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
