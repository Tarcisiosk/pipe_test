class CreatePipe < ActiveRecord::Migration[5.1]
  def change
    create_table :pipes do |t|
      t.string :name
      t.references :organization
      t.timestamps
    end
  end
end
