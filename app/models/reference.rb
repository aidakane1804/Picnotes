class Reference < ApplicationRecord
  belongs_to :note
  validates :title, presence: :true

  before_validation :smart_add_url_protocol

  def smart_add_url_protocol
    unless self.link[/\Ahttp:\/\//] || self.link[/\Ahttps:\/\//]
      self.link = "http://#{self.link}"
    end
  end
end
