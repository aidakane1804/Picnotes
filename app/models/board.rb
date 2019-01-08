class Board < ApplicationRecord
  belongs_to :user
  
  has_many :board_members
  has_many :members, through: :board_members

  def toggle_note(note)
    if has_note?(note)
      self.notes.delete(note)
    else
      self.notes.push(note)
    end
  end

  def board_name
    "#{board.name}"
  end

  def has_note?(note)
    note.board_id == self.id
  end
end
