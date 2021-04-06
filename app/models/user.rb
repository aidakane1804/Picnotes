class User < ApplicationRecord
  has_secure_password
  validates :password, length: {minimum: 8}, allow_nil: true

  acts_as_voter

  devise :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]
  # devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook]

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

  # --------------------------------------------------------------------------------------
  has_many :messages
  has_many :subscriptions
  has_many :chats, through: :subscriptions
  has_many :card_likes
  has_many :card_comment_likes
  has_many :edtrackers
  has_many :myedtools
  def existing_chats_users
    existing_chat_users = []
    self.chats.each do |chat|
      existing_chat_users.concat(chat.subscriptions.where.not(user_id: self.id).map {|subscription| subscription.user})
      # puts 'ok'
      # rails.logger.info existing_chat_users
    end
    existing_chat_users.uniq
  end

  # ---------------------------------------------------------------------------------------

  validates(:username, {
      presence: {message: 'must exist'},
      uniqueness: {message: 'already exist'},
  })

  validates(:first_name, {
      presence: {message: 'must exist'},
  })

  validates(:avatar, {
      presence: {message: 'must exist'},
  })

  validates(:last_name, {
      presence: {message: 'must exist'},
  })

  #validates_presence_of :avatar

  #
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

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first
    #Uncomment the section below if you want users to be created if they don't exist
    unless user
      user = User.new(name: data['name'], email: data['email'], username: data['email'], first_name: data['first_name'], last_name: data['last_name'], password: Devise.friendly_token[0,20])
      user.save(validate: false)
        # user = User.create(name: data['name'],
        #   email: data['email'],
        #   username: data['email'],
        #   first_name: data['first_name'],
        #   last_name: data['last_name'],
        #   password: Devise.friendly_token[0,20]
        # )
    end
    user
  end


  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end


  def self.create_from_provider_data(provider_data)
    where(provider: provider_data.provider, uid: provider_data.uid).first_or_create do |user|
      user.email = provider_data.info.email rescue nil
      name_slices = provider_data.info.name.gsub(/\s+/m, ' ').strip.split(" ")
      user.username = provider_data.info.name
      user.first_name = name_slices[0]
      user.image = provider_data.info.image
      user.avatar = provider_data.info.image
      user.last_name = name_slices[1]
      user.password = Devise.friendly_token[0, 20]
    end
  end

end
