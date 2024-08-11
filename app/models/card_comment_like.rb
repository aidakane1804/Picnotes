class CardCommentLike < ApplicationRecord
  belongs_to :edtracker , optional: true
  belongs_to :myedtool  , optional: true
  belongs_to :user ,optional: true
  # validates_presence_of :edtracker_id

end
