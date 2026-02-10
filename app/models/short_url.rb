class ShortUrl < ApplicationRecord
    validates :original_url, presence: true
    validates :code, presence: true, uniqueness: true
  
    has_many :clicks, dependent: :destroy
  end
  