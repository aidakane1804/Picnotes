class Edtracker < ApplicationRecord
  has_many :card_likes
  has_many :card_comment_likes
  belongs_to :user , optional: true
end
