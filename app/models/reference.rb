class Reference < ApplicationRecord
  belongs_to :note
  validates :title, presence: :true
end
