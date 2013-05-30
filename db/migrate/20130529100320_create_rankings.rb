class CreateRankings < ActiveRecord::Migration
  def change
    create_table :rankings do |t|
      t.integer :userid, :null => false
      t.string :name, :null => false
      t.float :winpercentage,  default: 0
      t.integer :level,  default: 0
      t.integer :xp,  default: 0
      t.integer :honor,  default: 0
      t.integer :military,  default: 0

      t.timestamps
    end
  end
end
