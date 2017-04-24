class AddPriorityToBug < ActiveRecord::Migration[5.0]
  def change
    add_column :bugs, :priority, :integer
  end
end
