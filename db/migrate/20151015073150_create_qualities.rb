class CreateQualities < ActiveRecord::Migration
  def change
    create_table :qualities do |t|
      t.string :name
      t.integer :order

      t.timestamps null: false
    end
  end
end
