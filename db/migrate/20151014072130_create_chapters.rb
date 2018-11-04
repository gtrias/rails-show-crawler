class CreateChapters < ActiveRecord::Migration[5.1]

  def change
    create_table :chapters do |t|
      t.integer :number
      t.references :season, index: true, foreign_key: true
      t.string :quality

      t.timestamps null: false
    end
  end
end
