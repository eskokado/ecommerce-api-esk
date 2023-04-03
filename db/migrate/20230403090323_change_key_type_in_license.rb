class ChangeKeyTypeInLicense < ActiveRecord::Migration[6.0]
  def up
    change_column :licenses, :key, :string
  end

  def down
    change_column :licenses, :key, :integer
  end
end
