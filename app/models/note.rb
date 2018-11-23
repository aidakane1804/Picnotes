class Note < ApplicationRecord
  has_many :likes, dependent: :destroy
  has_many :dislikes, dependent: :destroy
  has_many :favorites, as: :favorited

  acts_as_taggable_on :tags

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

  def self.search(search)
    if search
      note = Note.find_by(title: search)
      if note
        self.where(note_id: note)
      else
        Note.all
      end
    else
      Note.all
    end
  end

  private
  def set_defaults
    self.likes ||= 0
    self.dislikes ||= 0
  end
end
