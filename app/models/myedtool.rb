class Myedtool < ApplicationRecord
  has_many :card_comment_likes, dependent: :destroy
  has_many :card_likes
  has_many :card_comment_likes
  belongs_to :user , optional: true
  acts_as_taggable_on :tags
  acts_as_votable
end
