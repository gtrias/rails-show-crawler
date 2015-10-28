class Season < ActiveRecord::Base
  belongs_to :show
  has_many :chapters, dependent: :destroy

  validates :number, presence: true
end
