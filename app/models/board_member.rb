class BoardMember < ApplicationRecord
  belongs_to :member, class_name: 'User'
  belongs_to :board
end
