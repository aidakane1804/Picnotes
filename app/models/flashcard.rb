class Flashcard < ApplicationRecord
  serialize :flashcards, Hash
  belongs_to :user
end