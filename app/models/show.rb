class Show < ActiveRecord::Base
    has_and_belongs_to_many :qualities
    has_many :seasons, dependent: :destroy
end
