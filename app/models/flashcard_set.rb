class FlashcardSet < ApplicationRecord
  belongs_to :user
  serialize :flashcard, Hash 
end
