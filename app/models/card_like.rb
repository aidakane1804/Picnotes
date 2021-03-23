class CardLike < ApplicationRecord
  belongs_to :edtracker ,optional: true
  belongs_to :myedtool , optional: true
  belongs_to :user ,optional: true
end
