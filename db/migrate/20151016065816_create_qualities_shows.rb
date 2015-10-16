class CreateQualitiesShows < ActiveRecord::Migration
  def change
    create_table :qualities_shows, id: false do |t|
        t.belongs_to :show, index: true
        t.belongs_to :quality, index: true
    end
  end
end
