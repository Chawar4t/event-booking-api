class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :date
      t.integer :capacity

      t.timestamps
    end
  end
end
