class Tag < ApplicationRecord
    validates :name, presence: true
    validates :value, presence: true, numericality: true
end
