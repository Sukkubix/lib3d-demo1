class CreateAssets < ActiveRecord::Migration[7.0]
  def change
    create_table :assets do |t|
      t.references :project, null: false, foreign_key: true
      t.string :file, null: false

      t.timestamps
    end
  end
end
