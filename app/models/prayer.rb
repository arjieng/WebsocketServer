class Prayer < ApplicationRecord
	belongs_to :user
	has_many :prayer_comments
	belongs_to :group
end
