class Note < ApplicationRecord
  has_many :tags, dependent: :destroy
  has_many :references, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :dislikes, dependent: :destroy

  belongs_to :user

  mount_uploader :image, ImageUploader

  validates(:title, {
    presence: {message: 'Must have a Title'}
  })

  validates(:body, {
    presence: true,
    length: {minimum: 5, maximum: 2000}
  })

  after_initialize :set_defaults

  private
  def set_defaults
    self.likes ||= 0
    self.dislikes ||= 0
  end
end
