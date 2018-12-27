class Reference < ApplicationRecord
  belongs_to :note
  validates :title, presence: :true

  before_validation :smart_add_url_protocol

  TYPE = [
    ['Book', 't'],
    ['Video', 'v'],
    ['Article', 'p']
  ]

  def smart_add_url_protocol
    unless self.link[/\Ahttp:\/\//] || self.link[/\Ahttps:\/\//]
      self.link = "https://#{self.link}"
    end
  end
end
