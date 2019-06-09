class Tag < ApplicationRecord
    belongs_to :movie
    validates :name, presence: true
    validates :value, presence: true, numericality: true
    validates :value, presence: true, numericality: true
end
