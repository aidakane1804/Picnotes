class User < ApplicationRecord
  has_secure_password

  has_many :notes
  has_many :likes, dependent: :destroy
  has_many :liked_notes, through: :likes, source: :note
  has_many :dislikes, dependent: :destroy
  has_many :disliked_notes, through: :dislikes, source: :note

  has_many :favorites, dependent: :destroy
  has_many :favorited_notes, through: :favorites, source: :favorited, source_type: 'Note'

  has_many :boards, dependent: :destroy

  mount_uploader :avatar, ImageUploader

end
