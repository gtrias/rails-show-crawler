class Chapter < ActiveRecord::Base
  belongs_to :season

  validates :number, presence: true
end
