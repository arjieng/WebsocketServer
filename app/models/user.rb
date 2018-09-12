class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User
  
  mount_uploader :avatar, AvatarUploader
  # serialize :avatar, JSON

  has_many :group_members
  has_many :groups, through: :group_members
  has_many :chatroom_messages
  has_many :prayers
  has_many :prayer_comments
  # acts_as_messageable
  
end
