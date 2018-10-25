class Board < ApplicationRecord
  belongs_to :user
  has_many :notes

  def toggle_note(note)
    if has_note?(note)
      self.notes.delete(note)
    else
      self.notes.push(note)
    end
  end

  def has_note?(note)
    note.board_id == self.id
  end
end
