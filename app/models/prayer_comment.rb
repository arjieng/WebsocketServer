class PrayerComment < ApplicationRecord
	belongs_to :prayer
	belongs_to :user
end
