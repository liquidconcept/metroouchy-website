module Application
  class Event < ActiveRecord::Base
    mount_uploader :logo, Application::ImageUploader
  end
end
