class Note < ApplicationRecord

  attr_accessor :image, :image_cache, :remove_image

  has_many :likes, dependent: :destroy
  has_many :dislikes, dependent: :destroy
  has_many :favorites, as: :favorited

  has_many :references, dependent: :destroy

  acts_as_taggable_on :tags
  acts_as_votable

  belongs_to :user

  has_and_belongs_to_many :folders
  has_many :card_comment_likes, dependent: :destroy
  has_many :card_likes




  mount_uploader :image, ImageUploader

  validates(:title, {
    presence: {message: 'Must have a Title'}
  })

  validates(:body, {
    presence: true,
    length: {minimum: 2, maximum: 2000}
  })

  validates(:image, {
    presence: {message: 'Must have a Image'}
    })

    validates(:tag_list, {
      presence: {message: 'Must have a tag'}
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

  def slug
    self.title_slug
  end

  def previous tag: nil, user: nil, picnotes_type: nil
    notes = fetch_notes(tag: tag, user: user, picnotes_type: picnotes_type)

    notes.where("notes.id < ?", id).order(id: :desc).first || notes.first
  end

  def next tag: nil, user: nil, picnotes_type: nil
    notes = fetch_notes(tag: tag, user: user, picnotes_type: picnotes_type)

    notes.where("notes.id > ?", id).order(id: :asc).first || notes.last
  end
  
  def fetch_notes tag: nil, user: nil, picnotes_type: nil
    if tag
      Note.includes(:tags).where(tags: { name: tag }).all
    elsif user
      if picnotes_type == "my-picnotes"
        Note.where(user: user).order(id: :asc)
      elsif picnotes_type == "my-favorites"
        user.favorited_notes.where(archived: false).order(id: :asc)
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
