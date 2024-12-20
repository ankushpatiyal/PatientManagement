class CreatePatients < ActiveRecord::Migration[7.1]
  def change
    create_table :patients do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.date :date_of_birth
      t.datetime :next_appointment

      t.timestamps
    end

    add_index :patients, :email, unique: true
  end
end
