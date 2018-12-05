class User < ApplicationRecord
  has_secure_password
  acts_as_voter

  has_many :notes, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_notes, through: :likes, source: :note
  has_many :dislikes, dependent: :destroy
  has_many :disliked_notes, through: :dislikes, source: :note

  has_many :favorites, dependent: :destroy
  has_many :favorited_notes, through: :favorites, source: :favorited, source_type: 'Note'

  has_many :boards, dependent: :destroy

  mount_uploader :avatar, ImageUploader

  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  # helper methods

  # Follow Another User
  def follow(other)
    active_relationships.create(followed_id: other.id)
  end

  #Unfollow a user
  def unfollow(other)
    active_relationships.find_by(followed_id: other.id).destroy
  end

  #Is following a user?
  def follow?(other)
    following.include?(other)
  end
end
