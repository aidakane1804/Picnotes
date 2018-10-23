class Like < ApplicationRecord
  belongs_to :note
  belongs_to :user
end
