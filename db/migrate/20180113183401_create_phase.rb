class CreatePhase < ActiveRecord::Migration[5.1]
  def change
    create_table :phases do |t|
      t.string :name
      t.references :pipe
      t.timestamps
    end
  end
end
