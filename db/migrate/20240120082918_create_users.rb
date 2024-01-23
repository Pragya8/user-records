class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :uuid
      t.string :gender
      t.jsonb :name, default: {}
      t.jsonb :location, default: {}
      t.integer :age

      t.timestamps
    end
  end
end
