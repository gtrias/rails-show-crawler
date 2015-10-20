class Season < ActiveRecord::Base
  belongs_to :show
  has_many :chapter
end
