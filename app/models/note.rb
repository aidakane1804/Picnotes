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


  mount_uploader :image, ImageUploader

  # validates(:title, {
  #   presence: {message: 'Must have a Title'}
  # })

  validates(:body, {
    presence: true,
    length: {minimum: 5, maximum: 2000}
  })

  # validates(:image, {
  #   presence: {message: 'Must have a Image'}
  #   })

    # validates(:tag_list, {
    #   presence: {message: 'Must have a tag'}
    #   })

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

  def previous
    Note.where("id < ?", id).order(id: :desc).first || Note.last
  end

  def next
    Note.where("id > ?", id).order(id: :asc).first || Note.first
  end

  private
  def set_defaults
    self.likes ||= 0
    self.dislikes ||= 0
  end
end
