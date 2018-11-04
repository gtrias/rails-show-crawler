class CreateSeasons < ActiveRecord::Migration[5.1]
  def change
    create_table :seasons do |t|
      t.integer :number
      t.references :show, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
