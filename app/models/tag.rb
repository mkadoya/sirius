class Tag < ApplicationRecord
    validates :name, presence: true, length: { maximum: 15 }
    validates :value, presence: true, numericality: true
end
