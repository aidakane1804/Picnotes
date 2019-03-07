class User < ApplicationRecord
  has_secure_password
  validates :password, length: {minimum: 8}, allow_nil: true

  acts_as_voter

  # devise :omniauthable, :omniauth_providers => [:facebook]

  has_many :folders, dependent: :destroy

  has_many :notes, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_notes, through: :likes, source: :note
  has_many :dislikes, dependent: :destroy
  has_many :disliked_notes, through: :dislikes, source: :note

  has_many :favorites, dependent: :destroy
  has_many :favorited_notes, through: :favorites, source: :favorited, source_type: 'Note'

  mount_uploader :avatar, ImageUploader

  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  validates(:username, {
    presence: {message: 'must exist'},
    uniqueness: {message: 'already exist'}
  })

  validates(:first_name, {
    presence: {message: 'must exist'}
  })

  validates(:last_name, {
    presence: {message: 'must exist'}
  })

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  # The `validates` option `format:` takes a Regular Expression which is
  # way to verify that string is formatted in certain way. The regular expression
  # above tests that our emails begin with alpha numeric characters, have a @
  # in the middle which is followed by a word, a dot, then another word.
  validates :email,
    presence: true,
    uniqueness: true,
    format: VALID_EMAIL_REGEX

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

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image
    end
  end
end
