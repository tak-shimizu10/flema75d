class Evaluate < ApplicationRecord
    belongs_to :user
    enum rate: { good: 1, normal: 2, bad: 3 }
    validates :rate, presence: true
end
