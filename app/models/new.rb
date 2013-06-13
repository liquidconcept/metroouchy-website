module Application
  class New < ActiveRecord::Base
    mount_uploader :image, Application::ImageUploader
  end
end
