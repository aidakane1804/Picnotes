class EdFluencer < ApplicationRecord
	mount_uploader :image, FileUploader

	validates :first_name, presence: true
	validates :last_name, presence: true
	validates :title, presence: true
	validates :content, presence: true
	validates :image, presence: true
	validates :url, presence: true

end
