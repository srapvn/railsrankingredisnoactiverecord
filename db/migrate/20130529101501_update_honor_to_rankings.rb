class UpdateHonorToRankings < ActiveRecord::Migration
  def change
      change_column :rankings, :honor, :integer, default: 0
      change_column :rankings, :winpercentage, :float, default: 0.0
      change_column :rankings, :level, :integer, default: 0
      change_column :rankings, :xp, :integer, default: 0
      change_column :rankings, :military, :integer, default: 0
  end
  def down
  end
end
