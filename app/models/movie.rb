class Movie < ApplicationRecord
    mount_uploader :image, ImageUploader
    validates :item_id, presence: true, numericality: true
    validates :title, presence: true
    validates :outline, presence: true
    validates :director, presence: true
    validates :performer, presence: true
    validates :year, presence: true, numericality: true
    validates :preview, presence: true
    validates :image, presence: true
end
