class Event < ApplicationRecord
	has_many :attendees
	belongs_to :group
	mount_uploader :image, AvatarUploader
end
