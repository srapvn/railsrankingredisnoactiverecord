class CreateRankings < ActiveRecord::Migration
  def change
    create_table :rankings do |t|
      t.integer :userid, :null => false
      t.string :name, :null => false
      t.float :winpercentage
      t.integer :level
      t.integer :xp
      t.string :honor
      t.integer :military

      t.timestamps
    end
  end
end
