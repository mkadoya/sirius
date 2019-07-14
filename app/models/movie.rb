class Movie < ApplicationRecord
    mount_uploader :image, ImageUploader
    has_many :tags, dependent: :destroy
    validates :title, presence: true
    validates :outline, presence: true
    validates :director, presence: true
    validates :performer, presence: true
    validates :year, presence: true, numericality: true
    validates :preview, presence: true
    validates :image, presence: true
    validates :article, length: { maximum: 140 }
end
